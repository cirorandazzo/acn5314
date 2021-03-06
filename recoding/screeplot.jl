# Written by Athul Sudheesh, CMPUtils
# https://github.com/coinslab/CMPUtils.jl/blob/master/src/plotting.jl

function screeplot(S)
    hold(false)
    colorscheme("light")
    plot(1:length(S),S, title="Scree Plot", 
        xlabel = "Singular Value IDs",
        ylabel = "Singular Values", grid=false)
    hold(true)
    aspectratio(24/16)
    display(scatter(1:length(S),S,grid=false))
end