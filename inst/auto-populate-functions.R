projectModel <- c("dat1 = dat", "dat2")
dat1 = 2
dat2 = 3

# you could easily end up with scenarios where you are
# using global objects instead of local objects if you are not careful
# with the names.
func <- function(dat1_local = dat1, dat2_local = dat2) {
  dat1_local + dat2_local
}

func()

pmodel <- quote(dat1_local = dat1, dat2_local = dat2)
func2 <- function(pmodel) {
  dat1_local + dat2_local
}

func2()

y <- "hello"
parse(y)

f <- ?function(x) {
  quote(x)
}
f(1:10)
## 1:10
x <- 10
f(x)
## x

f(dat1_local = dat1, dat2_local = dat2) # error

y <- 13
f(x + y^2)
## x + y^2


# do we need to auto-populate function definitions? will this be confusing for users?
# better to let them define arguments
# ok if  we let people populate the arguments them selves - this also gives users more flexibility?
# flexibility of choosing values of arguments is kind of un-ncessary

test <- data.frame(a = 1:10, b = letters[1:10])
str(test)
attributes(test)

test2 <- structure(
  list(a = list(cheek = 1:10, dick = 4:99), b = letters[1:10]),
  class = c("monkey", "poop", "loo"),
  iam = "bored",
  heresalist = list(dingo = 2, dongo = "bong")
)
test2$a$dick


myfunc <- function(x, y) {
  x + y
}
class(myfunc)
str(myfunc)
class(myfunc) <- "woops"
attributes(myfunc)
myfunc

# ideally we would use something like fdaf <- function2() {fdsaf fdaf fda}
# where function2 updates the POM
# couldn't do checking if the object exists - they might not have created the object yet

# FUNDAMENTAL
# how will we know what functions are dependencies simply from the arguments unless we autopopulate?


# they would have to be named in correspondense with the function that create them, so we would then
# populate the POM from this - we would want to do this when the function is defined

# I don't
# think that we would be able to to grab the function arguments from inside because the the code to
# do this a) wouldn't be able to access the args and b) wouldn't get run untill the function did anyway
# so we would need a wrapper for function() - not as nice as autopopulating.
# although if we did have the POM code inside the function and accepted the function won't get
# added to POM immediately and run code to interrogate the func afterwards
# the the code is the first line then the code could just grab all the objs in the function environment
# but it would be very common to what the POM updated having just defined the function rather than having
# to run it aswell - could be very long run time!

# could just manually add function to DOM? updateDOM(<function-name>)
# could have updateDOM run through name class = funcitons in gloval env

# POM() could easily display all the funcs chosen to be in POM and all those that aren't
# similar set up to git. still has problem of needing arg names to match with dependency functions
# hold up - even if we were autopopulating and updating the POM directly, this would still be an issue,
# needing to match arg names with function names.
# best approach might be to simply allow POM tree to state whether or not any args are matched
# to

# possible approach - don't worry about arg names because args are always set be like:
# func2 <- function(x1 = func1(), x2 = func15()) {la la la}
# func3 <- functtion(x1 = fun2(), x2 = func1()) {fd fd fd} etc etc
# then call func3()
# then woudld use caching to make  sure the func is not rerun unless desired??? this sounds intricate?




# the user would then be expected to have to remove this func from the POM when it is removed


# autopopulating would mean we would need to have defaults for what the argumetns are assigned to,
# e.g. object with same name, or NULL
# it also means that users could add their own subsequent args that wouldn't be captured in the POM
# this does give greatly flexibility an it is concievable that even a data cleaning workflow
# could have a bunch of dependencies you wouldn't want in the POM - why wouldn't you want anything
# in the POM surely it is simpler to have everything in the POM then then subset what you don't want?
# also it avoid there being sytax to set the args in the POM, although it could be as simple as
# POM(<function-name>, arg1 = NULL, arg2 = NULL) etc.
# the atuopopulate would need to look like function(args(<func-name>), otherarg = 5, ortherarg2 = 6)

# this would solve the map out dependencies problem

# the second problem is:
# not just save object name but also rules for the object, like column types
# rather than specify it explicitly, it would probably be useful to auto genertate it from function
# but then you would have to have a system to choose when there is a bad new line in function code,
# or we actually want to change the output - could just have error the pops up but says press Y to
# overwrite.

out <- function() {
  mee <- 5
  inner <- function(x, y) {
    x + y
  }
}












