@testset "Geometry tests" begin
    @testset "Vector tests" begin
        u = Vector2D(1, 2)
        v = Vector2D(3, 4)
        @test v + u == Vector2D(4, 6)
        @test u - v == Vector2D(-2, -2)
        @test Vector2D(1.5, 2.0) ⋅ Vector2D(3.0, 4.0) == 1.5 * 3 + 2 * 4
        f = 1.5
        @test Vector2D(3, 4) * f == Vector2D(3*f, 4*f)
        
    end

    @testset "Circle tests" begin
        @testset "circle intersections" begin
            c1 = Circle(Point(1, 1), 4)
            c2 = Circle(Point(2, 1), 4)
            c3 = Circle(Point(10, 1), 4)
            c4 = Circle(Point(9, 1), 4)
            
            @test isintersecting(c1, c2)
            @test !isintersecting(c1, c3)
            @test !isintersecting(c1, c4)
        end
        
        # @testset "rectangle intersections" begin
        #     rect = Rect(Point(0.0, 0.0), Point(10.0, 10.0))
        #     c1 = Circle(Point(5.0, 5.0), 2.0)   # Clearly inside
        #     c2 = Circle(Point(5.0, 5.0), 5.0)   # Tagents inside
        #     c3 = Circle(Point(5.0, 5.0), 6.0)   # Clearly isintersecting
        #     c4 = Circle(Point(12.0, 5.0), 2.0)  # Tagents outside
        #     c5 = Circle(Point(12.0, 5.0), 1.0)  # Outside
        #     c6 = Circle(Point(15.0, 15.0), 5.0) # Would tagent in upper right corner if rect
        #
        #     # Circles placed at all the corners of rectangle
        #     c7 = Circle(Point(15.0, 15.0), 7.0)  # upper right
        #     c8 = Circle(Point(-5.0, -5.0), 7.0)  # lower left
        #     c9 = Circle(Point(-5.0, 15.0), 7.0)  # upper left
        #     c10 = Circle(Point(15.0, -5.0), 7.0) # lower right
        #
        #     @test isintersecting(c1, rect)  # Inside but !isintersectinging
        #     @test isintersecting(c2, rect)  # Tagents inside but !isintersectinging
        #     @test isintersecting(c3, rect)
        #     @test !isintersecting(c4, rect)
        #     @test !isintersecting(c5, rect)
        #     @test !isintersecting(c6, rect)
        #     @test !isintersecting(c7, rect)
        #     @test !isintersecting(c8, rect)
        #     @test !isintersecting(c9, rect)
        #     @test !isintersecting(c10, rect)
        # end
    end
end

