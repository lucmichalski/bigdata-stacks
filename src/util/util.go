package util

import "math/big"

const (
	HDFS_NUM_OF_PAGE = "/num_of_page"
	TMP_NUM_OF_PAGE  = "/tmp/num_of_page"
)

func ParseBigDecimal(s string) *big.Rat {
	r := new(big.Rat)
	r.SetString(s)
	return r
}

func FormatBigDecimal(f *big.Rat) string {
	return f.FloatString(20) // to 20 decimal place /* f.RatString() */
}

func DampingFactor(s string) (*big.Rat, *big.Rat) {
	b := ParseBigDecimal(s)

	i := new(big.Rat)
	i.Neg(b)

	a := new(big.Rat)
	a.Add(big.NewRat(1, 1), i)

	return a, b
}

func CalcPagerank(dA, dB, numOfPage, curRank *big.Rat) *big.Rat {
	a, b, c := new(big.Rat), new(big.Rat), new(big.Rat)

	// pagerank := (1 - 0.85) / numOfPage + 0.85 * curRank
	a.Quo(dA, numOfPage) // 0.15 / num of pages
	b.Mul(dB, curRank)   // 0.85 x curRank
	c.Add(a, b)          // i.e, 0.15 / num of pages + 0.85 x curRank

	return c
}
