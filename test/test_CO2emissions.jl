using Test
using MimiPAGE2020: co2emissions

for testscen in 1:2
    valdir, scenario, use_permafrost, use_seaice = get_scenario(testscen)
    println(scenario)

    m = test_page_model()

    scenario = addrcpsspscenario(m, scenario)
    co2emit = add_comp!(m, co2emissions)

    co2emit[:er_CO2emissionsgrowth] = scenario[:er_CO2emissionsgrowth]
    set_param!(m, :co2emissions, :e0_baselineCO2emissions, readpagedata(m, "data/e0_baselineCO2emissions.csv"))

    ##running Model
    run(m)

    emissions = m[:co2emissions,  :e_regionalCO2emissions]

    # Recorded data
    emissions_compare = readpagedata(m, "test/validationdata/$valdir/e_regionalCO2emissions.csv")

    @test emissions ≈ emissions_compare rtol = 1e-3
end
