using Random
using Distributions
using PGFPlotsX


Random.seed!(42)
#Generate Data
σ = 2      # std dev
x_min = -10 # xrange to plot
x_max = 10
μ_min = -5
μ_max = 5

dist = (μ, σ) ->  Normal(μ, σ)      # define the distribution
dists = [dist(μ, σ) for μ in -5:1:5]       # The set of distributions we're going to use
rnd = rand.(Truncated.(dists, x_min, x_max),10)  # Generates norm distributed data
dat_pdf = [(x) ->  pdf(d,x) for d in dists ] # Get the pdf of the dists

 x_pnts = collect(x_min:0.2:x_max)

# first mak a axes object
axis = @pgf Axis(
        {
            width = raw"1\textwidth",
            height = raw"0.5\textwidth",
            ymajorgrids,        # plot only gridlines in y direction
            xmax = x_max,         # set the plot range
            xmin = x_min,
            zmin = 0,
            "axis background/.style={fill=gray!10}",    # add some beauty
            "set layers",   # this is needed to make the scatter points appear behind the graphs
            view = raw"{30}{60}", # viewpoint
        },
        );

# first the jellow area at the bottom
@pgf y = Plot3(
        {
            "no marks",
            style ="{dashed}",
            color = "black",
            fill = "yellow",
            "fill opacity = 0.65",
            "on layer" = "axis background", # so we can see the grid lines trought
        },
            Table(x=[μ_min-σ, 0, μ_max+σ, 0], y=[length(rnd), 0, 0, length(rnd)],z=[0, 0, 0, 0] ),
            raw"\closedcycle",
        )
        push!(axis,y) # append the area to the axis

# second the scatter dots
@pgf for i in eachindex(dists)
        s = Plot3(
            {
                "only marks",
                color = "red",
                "mark options" = raw"{scale=0.4}",
                "mark layer" = "like plot",     # set the markers on the same layer as the plot
                "on layer" = "axis background",
            },
                Table(x = rnd[i], y= (length(dists)-i) *ones(length(rnd[i])), z=zeros(length(rnd[i].+0.1)) )
            )
            push!(axis,s)

    if i%2 ==0
        d= Plot3(
            {
                "no marks",
                style ="{thick}",
                color = "blue",
                "fill opacity=0.25",
                fill = "blue",
            },
                Table(x = x_pnts, y= (length(dists)-i) *ones(length(x_pnts)), z=dat_pdf[i](x_pnts) ),

            )
        push!(axis,d)
    end


    end
plot = @pgf TikzPicture({"scale"=>1},axis)

display(plot);

#PGFPlotsX.save("/users/fabianschneider/desktop/university/master/sem2/lab rotation III/julia/plot.pdf",plot)
