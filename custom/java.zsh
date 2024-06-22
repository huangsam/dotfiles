# Run fresh Maven install
alias mvci='mvn clean install'

# Show Maven dependency tree
alias mvdep='mvn dependency:tree'

# Skip Maven tests
alias mvskip='mvn -DskipTests'

# Setup Gradle assets for new project
alias grnew='gradle init wrapper'

# Show available Java JDKs
alias jdkmac='ls /Library/Java/JavaVirtualMachines'
alias jdklnx='ls /usr/lib/jvm'
