using Test
using MimiPAGE2020: LGforcing

for testscen in 1:2
    valdir, scenario, use_permafrost, use_seaice = get_scenario(testscen)
    println(scenario)

    m = test_page_model()

    add_comp!(m, LGforcing)

    set_param!(m, :LGforcing, :c_LGconcentration, readpagedata(m, "test/validationdata/$valdir/c_LGconcentration.csv"))

    # run Model
    run(m)

    forcing = m[:LGforcing,:f_LGforcing]
    forcing_compare = readpagedata(m, "test/validationdata/$valdir/f_LGforcing.csv")

    @test forcing ≈ forcing_compare rtol = 1e-3
end
