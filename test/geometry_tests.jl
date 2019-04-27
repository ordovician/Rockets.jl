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
    
    @testset "Matrix tests" begin
        @testset "matrix translations" begin
            p = Point(2, 3)
            trans = translate(Vector2D(4, 1))
            @test p*trans == Point(6, 4)
        end
        
        @testset "matrix rotations" for i in 1:6
            θ = π/i
            p = Point(1, 0)
            @test rotate(θ)*p ≈ Point(cos(θ), sin(θ))
            @test rotate(-θ)*p ≈ Point(cos(-θ), sin(-θ))
        end    
    end
    

    @testset "Rect tests" begin
        @testset "rect intersections" begin
            r1 = Rect(Point(1, 1), Point(4, 4))
            r2 = Rect(Point(2, 2), Point(3, 3))
            r3 = Rect(Point(2, 3), Point(5, 6))
            r4 = Rect(Point(5, 5), Point(6, 6))

            @test isintersecting(r1, r2)
            @test isintersecting(r1, r3)
            @test !isintersecting(r1, r4)
        end

        @testset "Rect surround points" begin
            r1 = Rect(Point(1, 1), Point(4, 4))
            r2 = surround(r1, Point(4, 5))
            @test r2 == Rect(Point(1, 1), Point(4, 5))
            r3 = surround(r2, Point(0, 0))
            @test r3 == Rect(Point(0, 0), Point(4, 5))
        end

        @testset "Rect translate" begin
            r1 = Rect(Point(1, 1), Point(4, 4))
            r1 = translate(r1, Vector2D(0, 3))
            @test r1 == Rect(Point(1, 4), Point(4, 7))
        end
    end

    @testset "Segment tests" begin
        @testset "segment intersections" begin
            s1 = Segment(Point(-1.0, 1.0), Point(2.0, 1.0))
            s2 = Segment(Point(0.0, 2.0), Point(0.0, -2.0))
            s3 = Segment(Point(-1.0, -2.0), Point(-1.0, 2.0))
            s4 = Segment(Point(-1.0, 0.0), Point(2.0, 0.0))
            s5 = Segment(Point(-2.0, 1.0), Point(-1.0, 1.0))
            s6 = Segment(Point(-2.0, 1.0), Point(0.0, 1.0))

            s7 = Segment(Point(1.0, 1.0), Point(4.0, 4.0))
            s8 = Segment(Point(1.0, 4.0), Point(4.0, 1.0))

            # NOTE: Parallell line Segmentments are defined as not intersecting even when they overlap
            @test intersection(s1, s2) == Point(0.0, 1.0)

            @test isintersecting(s7, s8)
            @test !isintersecting(s1, s1)  # Completly Overlapping and parallell
            @test isintersecting(s1, s2)   # Perpendicular
            @test isintersecting(s1, s3)   # Perpendicular
            @test !isintersecting(s1, s4)  # Parallell Segmentments
            @test !isintersecting(s1, s5)  # Tangenting Segmentmen parallell
            @test !isintersecting(s1, s6)  # Parallell overlapping
        end
        
        @testset "rect intersections" begin
            # TODO: implement isintersecting with segment and rect
            # rect = Rect(Point(0.0, 0.0), Point(2.0, 2.0))
            #
            # s1 = Segment(Point(1.0, -1.0), Point(1.0, 3.0)) # Across vertical
            # s2 = Segment(Point(-1.0, 1.0), Point(3.0, 1.0)) # Across horizontal
            # s3 = Segment(Point(-1.0, 1.0), Point(1.0, 1.0)) # Enter from left
            # s4 = Segment(Point(1.0, 1.0), Point(3.0, 1.0))  # Enter from right
            # s5 = Segment(Point(2.0, 1.0), Point(3.0, 2.0))  # Tangent left
            # s6 = Segment(Point(1.0, 2.0), Point(1.5, 3.0))  # Tangtn top
            #
            # s7 = Segment(Point(0.5, 0.5), Point(1.5, 1.0)) # Diagonal inside
            # s8 = Segment(Point(0.8, 0.0), Point(0.9, 1.0))    # Tagent inside
            # s9 = Segment(Point(3.0, 3.0), Point(4.0, 4.0))    # Outside
            # s10 = Segment(Point(-3.0, 1.0), Point(-1.0, 1.0))    # Outside
            #
            # @test isintersecting(s1, rect)
            # @test isintersecting(s2, rect)
            # @test isintersecting(s3, rect)
            # @test isintersecting(s4, rect)
            # @test isintersecting(s5, rect)
            # @test isintersecting(s6, rect)
            # @test !isintersecting(s7, rect) # Inside does not count as:intersectio
            # @test isintersecting(s8, rect)
            # @test !isintersecting(s9, rect)
            # @test !isintersecting(s10, rect)    
        end

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
