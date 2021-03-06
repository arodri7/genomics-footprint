# users can either step through this file, or call this file with 
# r -f example.R

# THIS ASSUMES THAT THE TESTHINT DATABASE EXISTS. The recipe for building that
# database is in ../dbInitialization/createHintTest.sql

# THIS EXAMPLE USES THE BRAIN HINT OUTPUT MADE BY RUNNING make hint at /scratch/data/footprints

print(date())
#-------------------------------------------------------------------------------
# set path to hint output 
data.path <- "/scratch/data/footprints/esophagus_hint_16"
#-------------------------------------------------------------------------------
# establish database connections:

if(!exists("db.hint"))
    db.hint <- "esophagus_hint_16_localhost"

if(!exists("db.fimo"))
    db.fimo <- "fimo_localhost"
#-------------------------------------------------------------------------------
# Source the libraries
source("../src/dependencies.R")
source("../src/dbFunctions.R")
source("../src/tableParsing.R")
source("../src/tests.R")
source("../src/main_Bioc.R")

if(!interactive()){    
    chromosomes <- paste0("chr",c(11:22,"X","Y","MT"))
    
    # Create parallel structure here    
    library(BiocParallel)    
    register(MulticoreParam(workers = 25, stop.on.error = FALSE, log = TRUE), default = TRUE)

    # Run on all 24 possible chromosomes at once
    result <- bptry(bplapply(chromosomes,fillAllSamplesByChromosome,
             dbConnection = db.hint,             
             fimo = db.fimo,             
             minid = "esophagus_hint_16.minid",             
             dbUser = "trena",             
             dbTable = "esophagus_hint_16",             
             sourcePath = data.path,             
             isTest = FALSE,             
             method = "HINT"))    
}

print(bpok(result))
print("Database fill complete")
print(date())
