/*
 *  Copyright (c) 2018-2020, Carnegie Mellon University
 *  See LICENSE for details
 */

#ifndef COMPLEX_GCC_INCLUDED
#define COMPLEX_GCC_INCLUDED

#include <pmmintrin.h>
#include <math.h>
#include <malloc.h>

#if defined(__ICL) || defined(_MSC_VER)
#define MALLOC(n) _mm_malloc(n, 16)
#else
#define MALLOC(n) memalign(16, n)
#endif

static __inline __m128d _swap_pd(__m128d x){
  return _mm_shuffle_pd(x,x,_MM_SHUFFLE2(0,1)); }

#define complex_t CPX
#define CPX __m128d
#define FLT __m128d
#define INT int
/* FIXME: this autolib macro is ugly and should not be here. */
#define LIB_iface_elt CPX

#define C_CPX(r,i) _mm_set_pd(i, r)
#define C_I  C_CPX(0, 1)
#define C_NI C_CPX(0, -1)

/* these are handled specially */
#define C_CPXN(r,i) C_CPX(r, i)
#define C_IM(a) _mm_set_pd(a, -(a))
#define C_FLT(a) _mm_set1_pd(a)
/* -- */
#define MUL_FLT_CPX(a, b) _mm_mul_pd(a, b)


#define C_INT(a) (a)

#define NTH_SYM(v,i) ((v)[i])

#define ADD_CPX_CPX(a,b) _mm_add_pd(a, b)
#define SUB_CPX_CPX(a,b) _mm_sub_pd(a, b)
#define NEG_CPX(a) _mm_sub_pd(C_FLT(0), a)
#define NTH_CPX(v,i) ((v)[i])
#define RE_CPX(v) _mm_unpacklo_pd(v, v)
#define IM_CPX(v) _mm_unpackhi_pd(v, v)

#define ADD_FLT_FLT(a,b) _mm_add_pd(a, b)
#define SUB_FLT_FLT(a,b) (_mm_sub_pd(a, b))
#define NTH_FLT(v,i) ((v)[i])
#define MUL_FLT_FLT(a, b) (_mm_mul_pd(a, b))
#define MUL_FLT_INT(a, b) (_mm_mul_pd(a, C_FLT(b)))
#define MUL_INT_FLT(a, b) (_mm_mul_pd(C_FLT(a), b))
#define DIV_FLT_FLT(a, b) (_mm_div_pd(a, b))
#define NEG_FLT(a) _mm_sub_pd(C_FLT(0), a)

#define MUL_FLT_UNK MUL_FLT_FLT
#define MUL_UNK_FLT MUL_FLT_FLT
#define MUL_INT_UNK MUL_INT_FLT
#define MUL_UNK_INT MUL_FLT_INT

#define ADD_INT_FLT(a,b) ADD_FLT_FLT(C_FLT(a), b)
#define ADD_INT_UNK(a,b) ADD_FLT_FLT(C_FLT(a), b)
#define ADD_FLT_INT(a,b) ADD_FLT_FLT(a, C_FLT(b))
#define ADD_UNK_INT(a,b) ADD_FLT_FLT(a, C_FLT(b))

#define FDIV_INT_INT(a,b) C_FLT(((double)a) / (b))
#define FDIV_FLT_INT(a,b) DIV_FLT_FLT(a, C_FLT(b))
#define FDIV_INT_FLT(a,b) DIV_FLT_FLT(C_FLT(a), b)
#define FDIV_FLT_FLT(a,b) DIV_FLT_FLT(a, b)

#define MUL_INT_INT(a,b) ((a) * (b))
#define ADD_INT_INT(a,b) ((a) + (b))
#define SUB_INT_INT(a,b) ((a) - (b))
#define AND_INT_INT(a,b) ((a) & (b))
#define XOR_INT_INT(a,b) ((a) ^ (b))
#define DIV_INT_INT(a,b) ((a) / (b))
#define IDIV_INT(a, b) ((a)/(b))
#define IMOD_INT(a, b) ((a)%(b))
#define NEG_INT(a) (-(a))
#define NTH_INT(v,i) ((v)[i])

/* MUL_I_CPX(x) : multiply complex x by I */
inline __m128d MUL_I_CPX(__m128d x) {
     __m128d t = x;
     t = _mm_shuffle_pd(t,t,_MM_SHUFFLE2(0,1));
     return _mm_xor_pd(t, _mm_set_sd(-0.0));
}

/* MUL_NI_CPX(x) : multiply complex x by -I */
inline __m128d MUL_NI_CPX(__m128d x) {
     __m128d t = x;
     t = _mm_xor_pd(t, _mm_set_sd(-0.0));
     return _mm_shuffle_pd(t,t,_MM_SHUFFLE2(0,1));
}

/* MUL_IM_CPX(a, x) : multiply complex x by a*I, in <a> 2 slots filled with same value */
inline __m128d MUL_IM_CPX(__m128d a, __m128d x) {
     __m128d t = x;
     t = _mm_shuffle_pd(t, t,_MM_SHUFFLE2(0,1));
     //return _mm_xor_pd(_mm_mul_pd(a, t), _mm_set_sd(-0.0));
     return _mm_mul_pd(a, t);
}

/* MUL_CPX_CPX(x, y) : multiply two complex numbers, res = x * y */
inline __m128d MUL_CPX_CPX(__m128d x, __m128d y) {
  /*x=IR,y=JS,z=RJ+IS RS-IJ*/
  __m128d v0,v1,v2,v3,v4;
  v0=_mm_unpacklo_pd(x,x);/*R R*/
  v1=_mm_unpackhi_pd(x,x);/*I I*/
  v2=_mm_mul_pd(v0,y);/*RJ RS*/
  v3=_mm_mul_pd(v1,y);/*IJ IS*/
  v4=_swap_pd(v3);/*IS IJ*/
  return _mm_addsub_pd(v2,v4);
}

/* MUL_CPXN_CPX(x, y) : multiply-conjugate two complex numbers, res = conj(x) * y,                                                  only last line is different */
inline __m128d MUL_CPXN_CPX(__m128d x, __m128d y) {
  /*x=IR,y=JS,z=RJ-IS RS+IJ*/
  __m128d v0,v1,v2,v3,v4,v5;
  v0=_mm_unpacklo_pd(y,y);/*S S*/
  v1=_mm_unpackhi_pd(y,y);/*J J*/
  v2=_mm_mul_pd(v0,x);/*IS RS*/
  v3=_mm_mul_pd(v1,x);/*IJ RJ*/
  v4=_swap_pd(v2);/*RS IS*/
  v5=_mm_addsub_pd(v4,v3);/*RS+IJ IS-RJ*/
  return _swap_pd(v5);
}


#define PI    3.14159265358979323846

extern double cos(double);
extern double sin(double);

static CPX omega(int N, int k) {
   CPX w;
   w = C_CPX(cos(2*PI*k/N), sin(2*PI*k/N));
   return w;
}

inline FLT cospi(FLT a) { double aa = ((double*)&a)[0]; return C_FLT(cos(PI*aa)); }

inline FLT sinpi(FLT a) {double aa = ((double*)&a)[0]; return C_FLT(sin(PI*aa)); }

#endif
