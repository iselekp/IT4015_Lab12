using Test
using DataFrames, CSV, Plots, Dates, Statistics, StatsBase, StatsPlots, GLM, Chain

# Include the name of your file; e.g. Lab12-TODO.jl at line 5 below. If it is the same filename, just uncomment line 5
# include("lab12-TODO.jl")

@testset "Lab12 Julia ETL and Visualization Tests" begin
    # Setup - load data once for all tests
    df_original = load_and_preprocess_data("sp_500_stock_price.csv")
    
    @testset "Task 1: Data Loading" begin
        @test df_original isa DataFrame
        @test !isempty(df_original)
        
        # Check decimal precision (2 digits)
        @test all(col -> all(x -> round(x, digits=2) == x, df_original[!, col]), 
            ["Dividend","Earnings","Consumer Price Index","Long Interest Rate","Real Price","Real Dividend","Real Earnings","PE10"])
    end

    @testset "Task 2: Normalization" begin
        df = deepcopy(df_original)
        normalize_numerical_columns!(df)
        for col in names(df, Real)
            @test all(0 .<= df[!, col] .<= 1)
        end
    end

    @testset "Task 3: Time Features" begin
        df = deepcopy(df_original)
        process_time_features!(df)
        
        expected_cols = ["Year", "Month", "Quarter"]
        @test all(col -> col ∈ names(df), expected_cols)
        @test all(2014 .<= df.Year .<= 2022)
    end

    @testset "Task 4: Statistics" begin
        df = deepcopy(df_original)
        process_time_features!(df)
        yearly_stats, monthly_stats, quarterly_stats = calculate_statistics(df)
        
        @test all(x -> x isa DataFrame, [yearly_stats, monthly_stats, quarterly_stats])
        @test size(monthly_stats, 1) == 11 # The dataset does not have any reporting on the month of October each year which is kinda strange!!!
        @test size(quarterly_stats, 1) == 4
    end

    @testset "Task 5: Visualizations" begin
        df = deepcopy(df_original)
        process_time_features!(df)
        @testset "Basic Visualizations" begin
            @test_nowarn create_visualizations(df)
            @test isfile("multiple-visualization.png")
        end
        
        @testset "Time Series Plots" begin
            df = deepcopy(df_original)
            @test_nowarn create_time_series_plots(df, 100)
            @test isfile("time-series-all-numericals.png")
        end
    end


    @testset "Main Function" begin
        @test_nowarn main()
    end
end