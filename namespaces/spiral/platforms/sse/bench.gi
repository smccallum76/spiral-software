
# Copyright (c) 2018-2020, Carnegie Mellon University
# See LICENSE for details


# Don't forget to Import(platforms.sse)

#NOTE:
# Bluestein breaks for SSE_2x64f -- disabled for small for now

# doParSimdDft seems broken
benchSSE := function()
    if LocalConfig.cpuinfo.SIMD().hasSSE2() then
        return rec(
            2x32f := rec(
                wht := rec(
                    small := _defaultSizes(s->doSimdWht(s, SSE_2x32f, rec(propagateNth := true, useDeref := true, verify := true, oddSizes := true, svct := true, stdTTensor := true, tsplPFA := false)), [4]),
                    medium := _defaultSizes(s->doSimdWht(s, SSE_2x32f, rec(propagateNth := true, useDeref := true, oddSizes := false, svct := true, stdTTensor := true, tsplPFA := false)), List([2..10], i->2^i))
                ),
                1d := rec(
                    dft_sc := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_2x32f, rec(propagateNth := true, useDeref := true, verify:=true, tsplBluestein:=false, interleavedComplex := true, PRDFT:=true, URDFT:= true, cplxVect := true, stdTTensor := false, globalUnrolling:=10000)), [ 2..32 ]),

                    ),
                    dft_ic := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_2x32f, rec(propagateNth := true, useDeref := true, verify:=true, tsplBluestein:=false, interleavedComplex := true, PRDFT:=true, URDFT:= true, cplxVect := true, stdTTensor := false, globalUnrolling:=10000)), [2..32])
                    )
                )
            ),
            2x64f := rec(
                wht := rec(
                    small := _defaultSizes(s->doSimdWht(s, SSE_2x64f, rec(verify := true, oddSizes := true, svct := true, stdTTensor := true, tsplPFA := false)), [4]),
                    medium := _defaultSizes(s->doSimdWht(s, SSE_2x64f, rec(oddSizes := false, svct := true, stdTTensor := true, tsplPFA := false)), List([2..10], i->2^i))
                ),
                1d := rec(
                    dft_sc := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_2x64f, rec(verify:=true, tsplBluestein:=false, interleavedComplex := false, PRDFT:=true, URDFT:= true, cplxVect := true, stdTTensor := false, globalUnrolling:=10000)),
                                [ 2..32 ]),
                        medium := _defaultSizes(s->doSimdDft(s, SSE_2x64f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := false)),
                                _svctSizes(1024, 16, 2)),
    #                    medium := spiral.libgen.doParSimdDft(SSE_2x64f, 1, _svctSizes(1024, 16, 4), false, true, false, false),
    #                    large := spiral.libgen.doParSimdDft(SSE_2x64f, 1, List([4..20], i->2^i), false, true, false, false)

                    ),
                    dft_ic := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_2x64f, rec(verify:=true, tsplBluestein:=false, interleavedComplex := true, PRDFT:=true, URDFT:= true, cplxVect := true, stdTTensor := false, globalUnrolling:=10000)),
                                [2..32]),
                        medium := _defaultSizes(s->doSimdDft(s, SSE_2x64f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := true)),
                                _svctSizes(1024, 16, 2)),
                        medium_cx := _defaultSizes(s->doSimdDft(s, SSE_2x64f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := true, cplxVect := true, realVect := false)),
                                _svctSizes(1024, 16, 2)),
    #                    medium := spiral.libgen.doParSimdDft(SSE_2x64f, 1, _svctSizes(1024, 16, 4), false, true, false, true),
    #                    large := spiral.libgen.doParSimdDft(SSE_2x64f, 1, List([4..20], i->2^i), false, true, false, true)
                    ),
                    trdft := _defaultSizes(s->doSimdSymDFT(TRDFT, s, SSE_2x64f, rec( verify:=true, 
                                interleavedComplex := true, PRDFT:=true, URDFT:= true, tsplBluestein := false, cplxVect := true,
                                realVect := true, propagateNth := true, useDeref := true, 
                                globalUnrolling:=10000)), 4*[1..32]),

                    dht := _defaultSizes(s->doSimdSymDFT(TDHT, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dct2 := _defaultSizes(s->doSimdSymDFT(TDCT2, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dct3 := _defaultSizes(s->doSimdSymDFT(TDCT3, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dct4 := _defaultSizes(s->doSimdSymDFT(TDCT4, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dst2 := _defaultSizes(s->doSimdSymDFT(TDST2, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dst3 := _defaultSizes(s->doSimdSymDFT(TDST3, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    dst4 := _defaultSizes(s->doSimdSymDFT(TDST4, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    mdct := _defaultSizes(s->doSimdSymDFT(TMDCT, s, SSE_2x64f, rec(verify :=true)), 8*[1..12]),
                    imdct := _defaultSizes(s->doSimdSymDFT(TIMDCT, s, SSE_2x64f, rec(verify :=true)), 8*[1..12])
                ),
                2d := rec(
                    dft_ic := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_2x64f, rec(interleavedComplex := true,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    4*List([1..16], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_2x64f, rec(verify:=true, interleavedComplex := true, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dft_sc := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_2x64f, rec(interleavedComplex := false,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    4*List([1..16], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_2x64f, rec(verify:=true, interleavedComplex := false, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dct2 := _defaultSizes(s->doSimdSymMDDFT(DCT2, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16]),
                    dct3 := _defaultSizes(s->doSimdSymMDDFT(DCT3, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16]),
                    dct4 := _defaultSizes(s->doSimdSymMDDFT(DCT4, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16]),
                    dst2 := _defaultSizes(s->doSimdSymMDDFT(DST2, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16]),
                    dst3 := _defaultSizes(s->doSimdSymMDDFT(DST3, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16]),
                    dst4 := _defaultSizes(s->doSimdSymMDDFT(DST4, s, SSE_2x64f, rec(verify := true)), [4, 8, 12, 16])
                )
            ),
            4x32i := rec(
                wht := rec(
                    small := _defaultSizes(s->doSimdWht(s, SSE_4x32i, rec(verify := true, oddSizes := true, svct := true, stdTTensor := true, tsplPFA := false)), List([], i->2^i)),
                    medium := _defaultSizes(s->doSimdWht(s, SSE_4x32i, rec(oddSizes := false, svct := true, stdTTensor := true, tsplPFA := false)), List([4..10], i->2^i))
                )
            ),
            4x32f := rec(
                wht := rec(
                    small := _defaultSizes(s->doSimdWht(s, SSE_4x32f, rec(verify := true, oddSizes := true, svct := true, stdTTensor := true, tsplPFA := false)), List([1..3], i->2^i)),
                    medium := _defaultSizes(s->doSimdWht(s, SSE_4x32f, rec(oddSizes := false, svct := true, stdTTensor := true, tsplPFA := false)), List([4..10], i->2^i))
                ),
                1d := rec(
                    dft_sc := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_4x32f, rec(verify:=true, interleavedComplex := false, stdTTensor := false, globalUnrolling:=10000)),
                                [ 2..64 ]),
                        medium := _defaultSizes(s->doSimdDft(s, SSE_4x32f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := false)),
                                _svctSizes(1024, 16, 4)),
    #                    medium := spiral.libgen.doParSimdDft(SSE_4x32f, 1, _svctSizes(1024, 16, 4), false, true, false, false),
    #                    large := spiral.libgen.doParSimdDft(SSE_4x32f, 1, List([4..20], i->2^i), false, true, false, false)

                    ),
                    dft_ic := rec(
                        small := _defaultSizes(s->doSimdDft(s, SSE_4x32f, rec(verify:=true, interleavedComplex := true, PRDFT:=true, URDFT:= true, cplxVect := true, stdTTensor := false, globalUnrolling:=10000)),
                                [ 2..64 ]),
                        medium := _defaultSizes(s->doSimdDft(s, SSE_4x32f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := true)),
                                _svctSizes(1024, 16, 4)),
                        medium_cx := _defaultSizes(s->doSimdDft(s, SSE_4x32f, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := true,
                                cplxVect := true, realVect := false, PRDFT := false, URDFT := true)),
                                _svctSizes(1024, 16, 4))
    #                    medium := spiral.libgen.doParSimdDft(SSE_4x32f, 1, _svctSizes(1024, 16, 4), false, true, false, true),
    #                    large := spiral.libgen.doParSimdDft(SSE_4x32f, 1, List([4..20], i->2^i), false, true, false, true)
                    ),
                    rdft := _defaultSizes(s->doSimdSymDFT(TRDFT, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    trdft := _defaultSizes(s->doSimdSymDFT(TRDFT, s, SSE_4x32f, rec( verify:=true, 
                                interleavedComplex := true, PRDFT:=true, URDFT:= true, tsplBluestein := false, cplxVect := true,
                                stdTTensor := false, realVect := true, propagateNth := true, useDeref := true, 
                                globalUnrolling:=10000)), 8*[1..32]),
                    dht := _defaultSizes(s->doSimdSymDFT(TDHT, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dct2 := _defaultSizes(s->doSimdSymDFT(TDCT2, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dct3 := _defaultSizes(s->doSimdSymDFT(TDCT3, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dct4 := _defaultSizes(s->doSimdSymDFT(TDCT4, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dst2 := _defaultSizes(s->doSimdSymDFT(TDST2, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dst3 := _defaultSizes(s->doSimdSymDFT(TDST3, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    dst4 := _defaultSizes(s->doSimdSymDFT(TDST4, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    mdct := _defaultSizes(s->doSimdSymDFT(TMDCT, s, SSE_4x32f, rec(verify :=true)), 32*[1..12]),
                    imdct := _defaultSizes(s->doSimdSymDFT(TIMDCT, s, SSE_4x32f, rec(verify :=true)), 32*[1..12])
                ),
                2d := rec(
                    dft_ic := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_4x32f, rec(interleavedComplex := true,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    16*List([1..8], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_4x32f, rec(verify:=true, interleavedComplex := true, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dft_sc := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_4x32f, rec(interleavedComplex := false,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    16*List([1..8], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_4x32f, rec(verify:=true, interleavedComplex := false, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dct2 := _defaultSizes(s->doSimdSymMDDFT(DCT2, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
                    dct3 := _defaultSizes(s->doSimdSymMDDFT(DCT3, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
                    dct4 := _defaultSizes(s->doSimdSymMDDFT(DCT4, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
                    dst2 := _defaultSizes(s->doSimdSymMDDFT(DST2, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
                    dst3 := _defaultSizes(s->doSimdSymMDDFT(DST3, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
                    dst4 := _defaultSizes(s->doSimdSymMDDFT(DST4, s, SSE_4x32f, rec(verify := true)), [4, 8, 12, 16]),
				# DO NOT USE BECAUSE IT GENERATES A NON_COMPATIBLE INIT() FUNCTION FOR USE WITH STANDARD TIMER
                #    conv := _defaultSizes(s->doSimdMdConv(s, SSE_4x32f, rec(svct := true, oddSizes := false, 
				#					splitComplexTPrm := true, TRCDiag_VRCLR := true, globalUnrolling := 150, measureFinal := false)),
				#					16*[1..32])
                )
            ),
            8x16i := rec(
                wht := rec(
                    small := _defaultSizes(s->doSimdWht(s, SSE_8x16i, rec(verify := true, oddSizes := true, svct := true, stdTTensor := true, tsplPFA := false)), List([1..5], i->2^i)),
                    medium := _defaultSizes(s->doSimdWht(s, SSE_8x16i, rec(oddSizes := false, svct := true, stdTTensor := true, tsplPFA := false)), List([6..10], i->2^i))
                ),
                1d := rec(
                    dft_ic := rec(
                        medium := _defaultSizes(s->doSimdDft(s, SSE_8x16i, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := true, verify := true)), 64*[1..4]),
                        small := _defaultSizes(s->doSimdDft(s, SSE_8x16i, rec(verify:=true, interleavedComplex := true, stdTTensor := false, globalUnrolling:=10000)), [2..16])
                    ),
                    dft_sc := rec(
                        medium := _defaultSizes(s->doSimdDft(s, SSE_8x16i, rec(tsplRader:=false, tsplBluestein:=false, tsplPFA:=false, oddSizes:=false, interleavedComplex := false, verify := true)), 64*[1..4]),
                        small := _defaultSizes(s->doSimdDft(s, SSE_8x16i, rec(verify:=true, interleavedComplex := false, stdTTensor := false, globalUnrolling:=10000)), [2..16])
                    ),
                    rdft := _defaultSizes(s->doSimdSymDFT(TRDFT, s, SSE_8x16i, rec(verify := true)), 128*[1..4]),
                    dht := _defaultSizes(s->doSimdSymDFT(TDHT, s, SSE_8x16i, rec(verify :=true)), 128*[1..4]),
                    dct2 := _defaultSizes(s->doSimdSymDFT(TDCT2, s, SSE_8x16i, rec(verify := true, fracbits := 8)), [128]),
                    dct3 := _defaultSizes(s->doSimdSymDFT(TDCT3, s, SSE_8x16i, rec(verify := true, fracbits := 8)), [128]),
                    dct4 := _defaultSizes(s->doSimdSymDFT(TDCT4, s, SSE_8x16i, rec(verify := true)), 128*[1..4]),
                    dst2 := _defaultSizes(s->doSimdSymDFT(TDST2, s, SSE_8x16i, rec(verify := true)), 128*[1..4]),
                    dst3 := _defaultSizes(s->doSimdSymDFT(TDST3, s, SSE_8x16i, rec(verify := true)), 128*[1..4]),
                    dst4 := _defaultSizes(s->doSimdSymDFT(TDST4, s, SSE_8x16i, rec(verify := true)), 128*[1..4]),
                    mdct := _defaultSizes(s->doSimdSymDFT(TMDCT, s, SSE_8x16i, rec(verify :=true)), 128*[1..4]),
                    imdct := _defaultSizes(s->doSimdSymDFT(TMDCT, s, SSE_8x16i, rec(verify :=true)), 128*[1..4])
                ),
                2d := rec(
                    dft_ic := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_8x16i, rec(interleavedComplex := true,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    64*List([1..2], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_8x16i, rec(verify:=true, interleavedComplex := true, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dft_sc := rec(
                        medium := _defaultSizes(s->doSimdMddft(s, SSE_8x16i, rec(interleavedComplex := false,
                                    oddSizes := false, svct := true, splitL := false, pushTag := true, flipIxA := false, stdTTensor := true, tsplPFA := false)),
                                    64*List([1..2], i->[i,i])),
                        small := _defaultSizes(s->doSimdMddft(s, SSE_8x16i, rec(verify:=true, interleavedComplex := false, globalUnrolling:=10000,
                                    tsplPFA := false, pushTag:= false, oddSizes := true, svct := true, splitL := false)),
                                    List([2..16], i->[i,i]))
                    ),
                    dct2 := _defaultSizes(s->doSimdSymMDDFT(DCT2, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16]),
                    dct3 := _defaultSizes(s->doSimdSymMDDFT(DCT3, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16]),
                    dct4 := _defaultSizes(s->doSimdSymMDDFT(DCT4, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16]),
                    dst2 := _defaultSizes(s->doSimdSymMDDFT(DST2, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16]),
                    dst3 := _defaultSizes(s->doSimdSymMDDFT(DST3, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16]),
                    dst4 := _defaultSizes(s->doSimdSymMDDFT(DST4, s, SSE_8x16i, rec(verify := true, fracbits := 10)), [8, 16])
                )
            )
        );
    else
        return false;
    fi;
end;
