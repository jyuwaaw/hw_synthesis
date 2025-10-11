### Post-route option ###
setAnalysisMode -analysisType onChipVariation -skew true -clockPropagation sdcControl

timeDesign  -preCTS -idealClock -numPaths 50 -prefix preCTS -outDir $rpt_path/preCTS              

setOptMode -yieldEffort none
setOptMode -effort high
setOptMode -maxDensity 0.95
setOptMode -fixDRC true
setOptMode -fixFanoutLoad true
setOptMode -optimizeFF true
setOptMode -simplifyNetlist false
setOptMode -holdTargetSlack 0.0
setOptMode -setupTargetSlack 0.0
clearClockDomains
setClockDomains -all
setOptMode -usefulSkew false
optDesign -preCTS -drv -outDir $rpt_path/preCTSOptTiming