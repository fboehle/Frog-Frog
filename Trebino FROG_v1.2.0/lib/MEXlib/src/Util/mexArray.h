/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _mexArrayH_
#define _mexArrayH_

#define _USE_MATH_DEFINES
#include <cstdlib>	// Must include stdlib before mex.h.
#include <complex>
#include <string>
#include <valarray>
#include "mex.h"

//! The real data type.
typedef double TReal;
//! The complex data type.
typedef std::complex<TReal> TCmplx;

/**	\brief Helper cless for ::TmexArray.
 *
 *	This class wraps two pointers to look like a complex value.
 */
class TmexCmplx
{
private:
	TReal *pR;	//!< Pointer to the real part.
	TReal *pI;	//!< Pointer to the imaginary part.

	//! The default constructor.
	TmexCmplx () { ; }

public:
	//! Create from two pointers.
	TmexCmplx (TReal *x, TReal *y) { pR = x; pI = y; }
	
	//!	The destructor.
	virtual ~TmexCmplx() {;}

	//! Assign a ::TCmplx value. 
	TmexCmplx& operator= (const TCmplx X)
	{
		if (pI) {
			(*pR) = std::real(X);
			(*pI) = std::imag(X);
		} else {
			(*pR) = std::real(X);
		}
		return *this;
	}

	//! Assign a ::TReal value. 
	TmexCmplx& operator= (const TReal X)
	{
		if (pI) {
			(*pR) = X;
			(*pI) = 0.0;
		} else {
			(*pR) = X;
		}
		return *this;
	}

	//! Add and assign a complex value. 
	TmexCmplx& operator+= (const TCmplx X)
	{
		if (pI) {
			(*pR) += std::real(X);
			(*pI) += std::imag(X);
		} else {
			(*pR) += std::real(X);
		}
		return *this;
	}

	//! Add and assign a ::TReal value. 
	TmexCmplx& operator+= (const TReal X)
	{
		if (pI) {
			(*pR) += X;
		} else {
			(*pR) += X;
		}
		return *this;
	}

	//! Convert to a complex value.
	operator std::complex<double>() const 
	{
		if (pI) return TCmplx(*pR, *pI);
		else return TCmplx(*pR, 0.0); 
	}
	
	//! Convert to a double value.
	operator double() const
	{
		return *pR;
	}
};

/**	\brief Wrapper for ::mxArray.
 *
 *	This class wraps ::mxArray in a easier to use interface.
 *
 *	\note This class does not own the resources in the ::mxArray,
 *		so we do not destroy it when the class is destroyed.
 */
class TmexArray
{
private:
	const mxArray *pArray;	//!< the ::mxArray being wrapped.
	std::valarray<int> sizes;
	std::valarray<int> indexer;

	/**	\brief Private default constructor.
	 *
	 *	The default constructor is private to prevent creating
	 *	a ::TmexArray without associating it with an ::mxArray.
	 */
	TmexArray(){;}
	
public:
	/**	\brief The real constructor.
	 *
	 *	Constructs a ::TmexArray from a ::mxArray.
	 *
	 *	\param X the ::mxArray to wrap.
	 */
	TmexArray(const mxArray *X):pArray(X), sizes(mxGetDimensions(X),mxGetNumberOfDimensions(X)),indexer(sizes)
	{
		for(size_t i = 1; i < indexer.size(); ++i)
			indexer[i] *= indexer[i-1];
	}
	
	/**	\brief The destructor.
	 *
	 *	The destructor is virutal to allow for using this class as
	 *	a base class.
	 */
	virtual ~TmexArray() {;}
	
	//!	Returns true if complex.
	bool IsComplex() const { return mxIsComplex(pArray); }
	
	//!	Returns true if an array.
	bool IsArray() const { return GetNumDims()==2 && (size_M() == 1 || size_N()==1); }
	
	//!	Returns true if a matrix.
	bool IsMatrix() const { return GetNumDims()==2 && !(size_M() == 1 || size_N()==1); }
	
	//! Returns the number of dimentions.
	size_t GetNumDims() const { return mxGetNumberOfDimensions(pArray); }

	//! Returns all the dimentions.
	const int* GetDims() const { return mxGetDimensions(pArray); }
	
	//!	Returns the total number of elements.
	size_t size() const { return mxGetNumberOfElements(pArray); }
	
	//!	Returns the number of elements in a dimention.
	size_t size(const size_t i) const { return sizes[i]; }
	
	//!	Returns the first array dimention.
	size_t size_M() const { return mxGetM(pArray); }
	
	//!	Returns the second array dimention.
	size_t size_N() const { return mxGetN(pArray); }
	
	/** \brief Standard array access.
	 *
	 *	This function accesses the data in the ::mxArray as if the array
	 *	were one dimentional.
	 *
	 *	\param i the array index.
	 *	\returns the value at point in complex notation.
	 */
	//@{
	TCmplx const operator[] (size_t i) const
	{
		if (mxGetPi(pArray))
			return TCmplx(mxGetPr(pArray)[i], mxGetPi(pArray)[i]);
		else
			return TCmplx(mxGetPr(pArray)[i], 0.0);
	}

	TmexCmplx operator[] (size_t i)
	{
		if (IsComplex())
			return TmexCmplx(mxGetPr(pArray) + i, mxGetPi(pArray) + i);
		else
			return TmexCmplx(mxGetPr(pArray) + i, NULL);
	}
	//@}

	/** \brief Functor array access.
	 *
	 *	This function accesses the data in the ::mxArray as if the array
	 *	were one dimentional.
	 *
	 *	\param i the array index.
	 *	\returns the value at point in complex notation.
	 */
	//@{
	TCmplx const operator() (size_t i) const
	{
		return operator[](i);
	}

	TmexCmplx operator() (size_t i)
	{
		return operator[](i);
	}
	//@}
	
	/** \brief Functor matrix access.
	 *
	 *	This function accesses the data in the ::mxArray as if the array
	 *	were two dimentional.
	 *
	 *	\param i the first matrix index.
	 *	\param j the second matrix index.
	 *	\returns the value at point in complex notation.
	 */
	//@{
	TCmplx const operator() (const size_t i, const size_t j) const
	{
		const size_t index = i + indexer[0]*j;
		return operator[](index);
	}

	TmexCmplx operator() (size_t i, size_t j)
	{
		const size_t index = i + indexer[0]*j;
		return operator[](index);
	}
	//@}

	/** \brief Functor matrix access.
	 *
	 *	This function accesses the data in the ::mxArray as if the array
	 *	were two dimentional.
	 *
	 *	\param i the first matrix index.
	 *	\param j the second matrix index.
	 *	\param k the third matrix index.
	 *	\returns the value at point in complex notation.
	 */
	//@{
	TCmplx const operator() (size_t i, size_t j, size_t k) const
	{
		const size_t index = i + indexer[0] * j + indexer[1] * k;
		return operator[](index);
	}

	TmexCmplx operator() (size_t i, size_t j, size_t k)
	{
		const size_t index = i + indexer[0] * j + indexer[1] * k;
		return operator[](index);
	}
	//@}

	/** \brief Functor matrix access.
	 *
	 *	This function accesses the data in the ::mxArray as if the array
	 *	were two dimentional.
	 *
	 *	\param i the first matrix index.
	 *	\param j the second matrix index.
	 *	\param k the third matrix index.
	 *	\param l the forth matrix index.
	 *	\returns the value at point in complex notation.
	 */
	//@{
	TCmplx const operator() (size_t i, size_t j, size_t k, size_t l) const
	{
		const size_t index = i + indexer[0] * j + indexer[1] * k + indexer[1] * l;
		return operator[](index);
	}

	TmexCmplx operator() (size_t i, size_t j, size_t k, size_t l)
	{
		const size_t index = i + indexer[0] * j + indexer[1] * k + indexer[1] * l;
		return operator[](index);
	}
	//@}
};

/**	\brief Returns true if complex.
 *
 *	Calls the function TmexArray::IsComplex.
 *
 *	\param X the ::TmexArray of interest.
 *	\retval true if the ::TmexArray is complex.
 *	\retval false if the ::TmexArray is not complex.
 */
bool IsComplex(const TmexArray &X)
{
	return X.IsComplex();
}

/**	\brief Returns true if X is an array.
 *
 *	Calls the function TmexArray::IsArray.
 *
 *	\param X the ::TmexArray of interest.
 *	\retval true if the ::TmexArray is an array.
 *	\retval false if the ::TmexArray is not an array.
 */
bool IsArray(const TmexArray &X)
{
	return X.IsArray();
}

/**	\brief Returns true if X is a matrix.
 *
 *	Calls the function TmexArray::IsMatrix.
 *
 *	\param X the ::TmexArray of interest.
 *	\retval true if the ::TmexArray is a matrix.
 *	\retval false if the ::TmexArray is not a matrix.
 */
bool IsMatrix(const TmexArray &X)
{
	return X.IsMatrix();
}

/** \brief Copies a mxArray to a std::string.
 *
 *	Copies an mxArray to a std::string.  This function
 *	assumes that the mxArray points to a character array.
 *
 *	\param X	the array to be copied.
 *	\returns	a std::string.
 */
std::string MakeString(const mxArray *X)
{
	int buflen = mxGetNumberOfElements(X)+1;

	char *cY = (char *)mxCalloc(buflen, sizeof(char));

	mxGetString(X, cY, buflen);

	std::string Y(cY);

	mxFree(cY);

	return Y;
}
#endif //_mexArrayH_
