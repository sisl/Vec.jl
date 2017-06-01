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

let
    L = Line(VecE2(0,0), VecE2(1,1))
    L2 = L + VecE2(-1,1)
    @test isapprox(L2.A, VecE2(-1,1))
    @test isapprox(L2.B, VecE2( 0,2))
    L2 = L - VecE2(-1,1)
    @test isapprox(L2.A, VecE2(1,-1))
    @test isapprox(L2.B, VecE2(2, 0))
    @test isapprox(get_polar_angle(L), atan2(1,1))
    @test isapprox(get_distance(L, VecE2(0,0)), 0)
    @test isapprox(get_distance(L, VecE2(1,1)), 0)
    @test isapprox(get_distance(L, VecE2(1,0)), √2/2)
    @test isapprox(get_distance(L, VecE2(0,1)), √2/2)
    @test get_side(L, VecE2(1,1)) ==  0
    @test get_side(L, VecE2(0,1)) ==  1
    @test get_side(L, VecE2(1,0)) == -1
end

let
    L = LineSegment(VecE2(0,0), VecE2(1,1))
    L2 = L + VecE2(-1,1)
    @test isapprox(L2.A, VecE2(-1,1))
    @test isapprox(L2.B, VecE2( 0,2))
    L2 = L - VecE2(-1,1)
    @test isapprox(L2.A, VecE2(1,-1))
    @test isapprox(L2.B, VecE2(2, 0))
    @test isapprox(get_polar_angle(L), atan2(1,1))
    @test isapprox(get_distance(L, VecE2(0,0)), 0)
    @test isapprox(get_distance(L, VecE2(1,1)), 0)
    @test isapprox(get_distance(L, VecE2(1,0)), √2/2)
    @test isapprox(get_distance(L, VecE2(0,1)), √2/2)
    @test get_side(L, VecE2(1,1)) ==  0
    @test get_side(L, VecE2(0,1)) ==  1
    @test get_side(L, VecE2(1,0)) == -1
end

let
    @test isapprox(intersect(Ray(-1,0,0), Ray(0,-1,π/2)), VecE2(0.0,0.0))

    @test  intersects(Ray(0,0,0), Ray(1,-1,π/2))
    @test !intersects(Ray(0,0,0), Ray(1,-1,-π/2))
    # @test  intersects(Ray(0,0,0), Ray(1,0,0)) # TODO: get this to work

    @test  intersects(Ray(0,0,0), Line(VecE2(0,0), VecE2(1,1)))
    @test !intersects(Ray(0,0,0), Line(VecE2(0,1), VecE2(1,1)))
    @test  intersects(Ray(0,0,0), Line(VecE2(1,0), VecE2(2,0)))
    @test  intersects(Ray(0,0,0), Line(VecE2(1,-1), VecE2(1,1)))
    @test  intersects(Ray(0,0,π/2), Line(VecE2(-1,1), VecE2(1,1)))
    @test !intersects(Ray(0,0,π/2), Line(VecE2(-1,1), VecE2(-1,2)))
    @test  intersects(Ray(0,0,π/2), Line(VecE2(-1,1), VecE2(-1.5,1.5)))

    @test  intersects(Ray(0,0,0), LineSegment(VecE2(0,0), VecE2(1,1)))
    @test !intersects(Ray(0,0,0), LineSegment(VecE2(0,1), VecE2(1,1)))
    @test  intersects(Ray(0,0,0), LineSegment(VecE2(1,0), VecE2(2,0)))
    @test !intersects(Ray(0,0,0), LineSegment(VecE2(-1,0), VecE2(-2,0)))
end


proj1 = Projectile(VecSE2(0.0,0.0,0.0), 1.0)
proj2 = Projectile(VecSE2(1.0,1.0,1.0), 1.0)
@test isapprox(VecE2(propagate(proj1, 2.0).pos), VecE2(2.0,0.0))
@test isapprox(VecE2(propagate(proj2, 0.0).pos), VecE2(1.0,1.0))

t_PCA, d_PCA = closest_time_of_approach_and_distance(proj1, Projectile(VecSE2(0.0,1.0,0.0), 1.0))
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 1.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(proj1, Projectile(VecSE2(0.0,2.0,0.0), 1.0))
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 2.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(proj1, Projectile(VecSE2(0.0,1.0,0.0), 2.0))
@test isapprox(t_PCA, 0.0)
@test isapprox(d_PCA, 1.0)

t_PCA, d_PCA = closest_time_of_approach_and_distance(Projectile(VecSE2(0.0,-0.0,0.2), 1.0), Projectile(VecSE2(0.0,1.0,-0.2), 1.0))
@test t_PCA > 0.0
@test isapprox(d_PCA, 0.0)

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