# Installation
alias mci='mvn clean install'

# Dependencies
alias mdt='mvn dependency:tree'
alias mdto='mvn dependency:tree -DoutputFile=mvn-deps.txt'
alias mdtml='mvn dependency:tree -DoutputType=ml'
alias mdtmlo='mvn dependency:tree -DoutputType=ml -DoutputFile=mvn-deps.ml'
