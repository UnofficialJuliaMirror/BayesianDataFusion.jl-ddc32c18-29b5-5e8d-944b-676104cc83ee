using BayesianDataFusion
using Base.Test

using DataFrames

## create entities
genes = Entity("genes")
pheno = Entity("pheno")

## features for entities
genes.F = rand(100, 5)
genes.lambda_beta = 3.0
pheno.F = rand(50, 8);

data = DataFrame(
        gene = sample(1:100, 1050),
        pheno = sample(1:50, 1050),
        value = rand(1050))

r  = Relation(data, "HPO", [genes, pheno])
r  = Relation(data, "HPO", [genes, pheno], class_cut = 0.5)
rd = RelationData()
addRelation!(rd, r)

@test r.class_cut == 0.5
@test genes.count == size(r, 1)
@test pheno.count == size(r, 2)
@test length(genes.relations) == 1
@test length(pheno.relations) == 1
@test length(r.entities)   == 2
@test length(rd.relations) == 1
@test length(rd.entities)  == 2

result = macau(rd, burnin=10, psamples=10, verbose=false)

r2  = Relation(sprand(100, 50, 0.01), "HPO2", [Entity("genes2"), Entity("pheno2")])
@test size(r2) == (100, 50)
@test length(r2.entities)  == 2
rd2 = RelationData(r2)
@test length(rd2.relations) == 1
@test length(rd2.entities)  == 2
result = macau(rd2, burnin = 2, psamples = 2, verbose = false)
