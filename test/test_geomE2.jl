@test isapprox(deltaangle(0.0, 0.0),  0.0)
@test isapprox(deltaangle(0.0, 1.0),  1.0)
@test isapprox(deltaangle(0.0, 2π),  0.0, atol=1e-10)
@test isapprox(deltaangle(0.0, π + 1.0), -(π- 1.0))

@test isapprox(angledist(0.0, 0.0), 0.0)
@test isapprox(angledist(0.0, 1.0), 1.0)
@test isapprox(angledist(0.0, 2π), 0.0, atol=1e-10)
@test isapprox(angledist(0.0, π + 1.0), π- 1.0)

@test isapprox(lerp_angle(0.0, 0.0, 1.0), 0.0)
@test isapprox(lerp_angle(0.0, 2π, 0.5), 0.0, atol=1e-10)
@test isapprox(lerp_angle(0.0, 2.0, 0.75),  1.5)
@test isapprox(lerp_angle(0.0, 2π-2, 0.75), -1.5)

@test are_collinear(VecE2(0.0,0.0), VecE2(1.0,1.0), VecE2(2.0,2.0))
@test are_collinear(VecE2(0.0,0.0), VecE2(1.0,1.0), VecE2(-2.0,-2.0))
@test are_collinear(VecE2(0.0,0.0), VecE2(0.5,1.0), VecE2(1.0,2.0))
@test are_collinear(VecE2(1.0,2.0), VecE2(0.0,0.0), VecE2(0.5,1.0))
@test !are_collinear(VecE2(0.0,0.0), VecE2(1.0,0.0), VecE2(0.0,1.0))

@test isapprox(ray_future_position(VecSE2(1.0,1.0,1.0), 1.0, 0.0), VecE2(1.0,1.0))
@test isapprox(ray_future_position(VecSE2(0.0,0.0,0.0), 1.0, 2.0), VecE2(2.0,0.0))

t_PCA, d_PCA = closest_time_of_approach_and_distance(VecSE2(0.0,0.0,0.0), 1.0, VecSE2(0.0,1.0,0.0), 1.0)
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 1.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(VecSE2(0.0,0.0,0.0), 1.0, VecSE2(0.0,2.0,0.0), 1.0)
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 2.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(VecSE2(0.0,0.0,0.0), 1.0, VecSE2(0.0,1.0,0.0), 2.0)
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 1.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(VecSE2(0.0,-0.0,0.2), 1.0, VecSE2(0.0,1.0,-0.2), 1.0)
@test t_PCA > 0.0
@test isapprox(d_PCA, 0.0)

@test isapprox(get_intersection(VecSE2(-1,0,0), VecSE2(0,-1,π/2)), VecE2(0.0,0.0))

@test intersects(VecSE2(0,0,0), VecSE2(1,-1,π/2))
@test !intersects(VecSE2(0,0,0), VecSE2(1,-1,-π/2))
# @test intersects(VecSE2(0,0,0), VecSE2(1,0,0))

@test  contains(Circ(0,0,1.0), VecE2(0,0))
@test !contains(Circ(2,0,1.0), VecE2(0,0))
@test  contains(Circ(2,0,1.0), VecE2(1.5,0))

box = AABB(VecE2(0.0, 0.5), 2.0, 5.0)
@test  contains(box, VecE2( 0.0,0.0))
@test  contains(box, VecE2(-1.0,0.0))
@test !contains(box, VecE2(-2.0,0.0))
@test !contains(box, VecE2( 1.0,3.1))

box = AABB(VecE2(-1.0, -2.0), VecE2(1.0, 3.0))
@test  contains(box, VecE2( 0.0,0.0))
@test  contains(box, VecE2(-1.0,0.0))
@test !contains(box, VecE2(-2.0,0.0))
@test !contains(box, VecE2( 1.0,3.1))

box = OBB(VecSE2(0.0, 0.5, 0.0), 2.0, 5.0)
@test  contains(box, VecE2( 0.0,0.0))
@test  contains(box, VecE2(-1.0,0.0))
@test !contains(box, VecE2(-2.0,0.0))
@test !contains(box, VecE2( 1.0,3.1))

box = OBB(VecSE2(0.0, 0.0, π/4), 2.0, 2.0)
@test  contains(box, VecE2( 0.0,0.0))
@test  contains(box, VecE2( 1.0,0.0))
@test  contains(box, VecE2( √2/2-0.1,√2/2-0.1))
@test !contains(box, VecE2( 1.0,1.0))
@test !contains(box, VecE2( √2/2+0.1,√2/2+0.1))