
clustering time series, further analyze each cluster 
cluster to five group
choose best samples(good periodicity) from each group.

fourier analysis
freqset/pattern mining
subsequence match

requirements:
periodic trend
at low price position
low p/e
no recently dividend/great drop
considering day/week/month cycle, different time scale
low cor between stocks
large max-min
large volume

features
aggregation features: periodicity_T, periodicity_cor, price_level, price_prop, price_avg, price_sd, cluster_id
static features: volume, pe, eps, market_cap

score can be calculated based on these features
clustering can be used to further analysis
supervised learning ? (label: will the price go up in the next period? )

code:
config.r
read_data(time_span, start_day);



