using DataFrames
using CSV
using LinearAlgebra
using GRUtils
include("screeplot.jl")

nosvd_data_path = joinpath(pwd(), "recoding/recoded_data/noSVD")
svd_data_path = joinpath(pwd(), "recoding/recoded_data/SVD")

# LOAD AND SEGMENT BEHAVIOR DATA
beh_data_path = joinpath(nosvd_data_path, "201222_beh_binned.csv");
beh = CSV.read(beh_data_path, DataFrame)
X_beh = Array(beh[!,Not([:Column1, :correct])])
y_beh = Array(beh[!,:correct])

# SVD OF BEH
beh_svd = svd(X_beh)
S = Diagonal(beh_svd.S)
Uw = beh_svd.U
Vt = beh_svd.Vt
screeplot(beh_svd.S ./norm(beh_svd.S))

# Store only first n singular values of beh. Choose based on Scree plot
n_sing_vals = 6; # number of singular values to keep
beh_sing_comps = DataFrame(Uw[:,1:n_sing_vals], :auto)

beh_sing_comps[:, "correct"] = y_beh # add "correct" back

CSV.write(joinpath(svd_data_path,"201222_beh_svd.csv"),  beh_sing_comps)

# Load sleep data
pre_data_path = joinpath(nosvd_data_path, "201222_pre_sws_binned.csv");
pre = CSV.read(pre_data_path, DataFrame)
pre = Array(pre[!,Not([:Column1])])

post_data_path = joinpath(nosvd_data_path, "201222_post_sws_binned.csv");
post = CSV.read(post_data_path, DataFrame)
post = Array(post[!,Not([:Column1])])

# Apply SVD to sleep data
Upre = pre * inv(Vt) * inv(S)
Upost = post * inv(Vt) * inv(S)

# Keep same number of singular components
pre_sing_comps = DataFrame(Upre[:,1:n_sing_vals], :auto)
post_sing_comps = DataFrame(Upost[:,1:n_sing_vals], :auto)

CSV.write(joinpath(svd_data_path,"201222_pre_svd.csv"),  pre_sing_comps)
CSV.write(joinpath(svd_data_path,"201222_post_svd.csv"),  post_sing_comps)