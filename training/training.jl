using DataFrames
using CSV
using ScikitLearn
using PyPlot

beh_data_path = joinpath(pwd(), "recoding/recoded_data/201222_beh_binned.csv")
pre_data_path = joinpath(pwd(), "recoding/recoded_data/201222_pre_sws_binned.csv")
post_data_path = joinpath(pwd(), "recoding/recoded_data/201222_post_sws_binned.csv")

beh = CSV.read(beh_data_path, DataFrame)
pre = CSV.read(pre_data_path, DataFrame)
post = CSV.read(post_data_path, DataFrame)