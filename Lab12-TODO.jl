# Import required packages for data manipulation, visualization, and statistical analysis
using DataFrames, CSV, Plots, Dates, Statistics, StatsBase, StatsPlots, GLM, Chain

"""
Task 1: Load and preprocess S&P 500 stock price data
"""
function load_and_preprocess_data(filepath)
    # Load CSV data into a DataFrame structure
    df = DataFrame(CSV.read(filepath, DataFrame))
    
    # Transform numeric columns to 2 significant digits
    numeric_columns = ["SP500", "Dividend", "Earnings", "Consumer Price Index", "Long Interest Rate", "Real Price", "Real Dividend", "Real Earnings", "PE10"]
    for i in numeric_columns
        df[!, i] = round.(df[:, i], digits=2)# Only keep two decimal digits for each numeric column
    end
    return df
end

"""
Task 2: Normalize numerical columns using min-max scaling
"""
function normalize_numerical_columns!(df)
    # Get names of all numeric columns in the DataFrame
    num_cols = names(df, Real)
    for col in num_cols
        # Implement min-max scaling formula
        max = maximum(df[!, col])
        min = minimum(df[!, col])
        df[!, col] = broadcast(/, broadcast(-, df[!, col], min), max-min)
        # Formula: (x - min(x)) / (max(x) - min(x))
    end
end

"""
Task 3: Create time-based features and filter data
"""
function process_time_features!(df)
    # TODO: Add time-based columns (Year, Month, Quarter)
    # Extract year, month, and quarter from the Date column
    df.Year = year.(df.Date)
    df.Month = month.(df.Date)
    month_quarters = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4]
    df.Quarter = month_quarters[df.Month]
    # Filter DataFrame to keep only rows between 2014-2022
    filter!(row -> 2014 <= year(row.Date) <= 2022, df)
end

"""
Task 4: Calculate aggregated statistics
"""
function calculate_statistics(df)
    # TODO: Calculate yearly aggregated statistics using combine and groupby operations
    yearly_stats = # Your code here
    
    # Calculate sum of dividends by month
    monthly_stats = combine(groupby(df, :Month), :Dividend => sum)
    # Calculate sum of dividends by quarter
    quarterly_stats = combine(groupby(df, :Quarter), :Dividend => sum)
    return yearly_stats, monthly_stats, quarterly_stats
end

"""
Task 5A: Create 1D visualizations
"""
function create_visualizations(df)
    # TODO: Create three different types of plots for data visualization
    p1 = # Create boxplot here
    p2 = # Create histogram here
    p3 = # Create scatter plot here
    
    # Combine all three plots into a single figure
    combined_plot = plot(p1, p2, p3, layout=(1,3), size=(1200,400))
    # Save the combined visualization to a PNG file
    savefig(combined_plot, "multiple-visualization.png")
end

"""
Task 5B: Create time series plots for 2D visualizations
"""
function create_time_series_plots(df, n)
    # Get all numerical column names
    num_cols = names(df, Real)
    # Initialize array to store individual plots
    plots = []
    # Define color palette for different plots
    colors = [:blue, :red, :green, :purple, :orange, :brown, :pink, :gray, :cyan]
    
    # Sort dates in reverse order and take first n entries
    sorted_dates = sort(df[1:n, :Date], rev=true)
    
    # TODO: Create time series plots for each numerical column
    
    # Combine all plots into a 3x3 grid
    final_plot = plot(plots..., layout=(3,3), size=(4800,4800))
    # Save the final visualization
    savefig(final_plot, "time-series-all-numericals.png")
end

# Main execution function
function main()
    # Load and prepare the dataset
    df = load_and_preprocess_data("sp_500_stock_price.csv")
    #println(first(df, 5))
    #println(names(df))
    println(describe(df))

    # Normalize all numerical columns
    normalize_numerical_columns!(df)
    println(describe(df))
    # Process and add time-based features
    process_time_features!(df)
    println(describe(df))
    println(first(df, 5))
    
    # Calculate various statistical measures
    #yearly_stats, monthly_stats, quarterly_stats = calculate_statistics(df)
    # Create visualization plots
    #create_visualizations(df)
    
    # Remove time-based columns to avoid redundancy in time series plots
    #select!(df, Not([:Year, :Month, :Quarter]))
    # Create time series plots for the most recent 100 entries
    #create_time_series_plots(df, 100)
end

# Execute the main function
main()
