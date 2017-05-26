# Installation
alias mci='mvn clean install'

# List dependencies
alias mdt='mvn dependency:tree'
alias mdtml='mvn dependency:tree -DoutputType=graphml'
alias mdtdot='mvn dependency:tree -DoutputType=dot'
alias mdttgf='mvn dependency:tree -DoutputType=tgf'

# Write dependency listings to disk
alias mdto='mvn dependency:tree -DoutputFile=mvn-deps.txt'
alias mdtoml='mvn dependency:tree -DoutputType=graphml -DoutputFile=mvn-deps.ml'
alias mdtocompile='mvn dependency:tree | grep ":compile" > "$(git symbolic-ref --short HEAD)-compile.txt"'
alias mdtotest='mvn dependency:tree | grep ":test" > "$(git symbolic-ref --short HEAD)-test.txt"'
