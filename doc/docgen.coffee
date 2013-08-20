_ = require('customscore')
fs = require('fs')

md2html = do ->
    head = """
    <head>
        <link rel="stylesheet" type="text/css" href="/assets/styles/style.css">
        <link rel="stylesheet" type="text/css" href="/assets/styles/classes.css">
        <title>The Funject Class</title>
    </head>
    <div class=container>
    <article>

    <!--<nav>
        <a href=/#>Welcome</a>
        <a href=/#install>Install</a>
        <a href=/#learn>Learn</a>
        <a href=/#docs>Docs</a>
    </nav>-->

    <h1>The Funject Class</h1>

    <p>This page details the properties of the Funject class. To learn about what the Funject class is and how you would use it, read about them in this <a href=/#builtin-type-Funject>tutorial.</a></p>

    <p>Please note that this reference is elliptical because we autogenerated it. Consider it not a lesson but a reference.</p>"""

    feet = """\n
    </article>
    </div>"""

    patterns = 
        '^(#{1,6})(.+)': (_, pounds, header) ->
            "<h#{pounds.length}>#{header}</h#{pounds.length}>"
        '^>\ (.*)$': (_, escaped) -> escaped
        '^([^ \n][^#\n]*)(?:#([^\n]+))?$': (_, name, description) ->
            """<div class=definition>
                <h3 class=name>#{name}</h3>
                #{description ? 'what is sounds like.'}
               </div>"""

    (name, str) ->
        head.replace(/Funject/g, name) +
        str
            .split('\n')
            .map((str) ->
                    for pattern, conseq of patterns
                        if (m = str.match(pattern))?
                            return conseq.apply({}, m)

                    return '')
            .join('\n') +
        feet

if process.argv[2]?
    _.streamToString(process.stdin, (str) ->
        fs.writeFileSync("./../site/doc/lib/#{process.argv[2]}.html"
                         md2html(process.argv[2], str)))
else
    fs.readdir('./library funjects for site', (err, filenames) ->
        for filename in filenames
            classname = filename.match(/.+(?=\.md)/)[0]
            fs.writeFileSync("./../site/doc/lib/#{classname}.html"
                             md2html(classname,
                                     fs.readFileSync("./library funjects for site/#{filename}").toString())))






###
is x # identity comparison; when one changes, the other changes
== x # tests for deep equality between lists and identity between funjects and primitive types; subclasses may override

.apply[x] # => receiver x
.then[f] # => f[receiver]; ex: arr.lots-of-long-methods.then[{[arr]: arr[arr.length - 1]}]
.on f # => f receiver; allows conditionals and switch-cases without additional syntax

.while-true f # repeatedly invokes f[] while reciever[] evaluates to true
.do-while-true f # invokes f[], then repeatedly invokes f[] while reciever[] evaluates to true

.has?[k] # true if the receiver matches k
.copy or clone # creates a copy of the funject

.prepend![{k: v}] # sets k equal to v at the bottom of the funject
.insert![i, {k: v}] # sets k equal to v before the ith pair

.number?
.string?
.boolean?
.symbol?
.unknown?
.nil?
.list?

.integer? # true if the receiver is a number and has no fractional component
.float? # true if the receiver is a number and has a fractional component

.member-of?[c] # true if receiver is an instance of class c
.kind-of?[c] # true if the receiver is an instance of class c or one of its subclasses

.to-string # a human-readable string representation
.inspect # a debugger-friendly string representation

.silently # a funject which matches the same arguments as the receiver and returns nil where an error would normally occur
###