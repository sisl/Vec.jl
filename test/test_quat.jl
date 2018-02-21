let
    q = Quat(1.0,2.0,3.0,4.5)
    @test length(q) == 4
    @test vec(q) == [1.0,2.0,3.0,4.5]
    @test vec(copy(q)) == vec(q)
    @test convert(Quat, [1.0,2.0,3.0,4.5]) == q
    @test norm(q) == norm(vec(q))
    @test vec(normalize(q)) == vec(q) ./ norm(vec(q))

    q = Quat(-0.002, -0.756, 0.252, -0.604)
    sol = push!(vec(get_axis(q)), get_rotation_angle(q))
    @test isapprox(sol, [-0.00250956, -0.948614,  0.316205, mod2pi(-1.84447)], atol=1e-3) ||
          isapprox(sol, [ 0.00250956,  0.948614, -0.316205, mod2pi( 1.84447)], atol=1e-3)
end
