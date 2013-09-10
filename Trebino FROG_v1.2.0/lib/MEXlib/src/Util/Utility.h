/**	\file
 *
 *	\author Erik Zeek
 *	\date $Date: 2006-11-11 00:15:30 $
 *	\version $Revision: 1.1 $
 */

#ifndef _UtilityH_
#define _UtilityH_


//! Shifts the parameters one to the left.
template <class T>
inline void SHFT(T &a, T &b, T &c, const T &d)
{
	a = b;
	b = c;
	c = d;
}

//! An templated absolute value function.
template <class T>
inline T ABS(T a) {
	return ((a) > 0.0 ? a : -a);
}

//! Returns the first paramter with the sign of the second.
template <class T, class U>
inline T SIGN(T a, U b) {
	return ((b) > 0.0 ? ABS(a) : -ABS(a));
}

//!	Returns the maximum of the two parameters.
template <class T>
inline T max(T x, T y)
{
	return (x > y) ? x : y;
}

#endif //_UtilityH_
