
Parham raised a number of important points about building software, all centred around the fact that software is a human-centric job. Yes, the code we write is performed by a machine, but as the famous saying goes - code is read more times than it's written.

**Imagine murdering them**


> Any fool can write code that a computer can understand. Good programmers write code that humans can understand.
> Martin Fowler

One of Parham's first points was that "no one lists readability or maintainability as a language feature... But it's important". It's definitely interesting seeing that of all the programming languages we have, none of them really praise the readability it provides as a function. And you'll hear __praise__ for functional languages, or those that allow you to turn a large method into a single line of code, but you'll realise that actually it's not something that you really want.

I recently found this when I was debugging a Groovy script that used [Closures][groovy-closures] and its use of trying to fit three closures, a map, and an if statement into three lines made the code very difficult to debug. Being "clever" and participating in [Code Golf][code-golf] is the easiest way to single-handedly enrage future programmers - who may in fact be you!

Parham discussed how languages that don't require explicit error handling can be very costly - for instance, a project he worked on where a `catch` could have saved £3m and a business. The fact that this is enforced in Go gives him a lot more comfort in the code he writes, as it won't be able to blow up as easily.

He went on to discuss how best practices won't always end up with a successful business, but writing suboptimal code often does, due to the time and effort cost in ensuring that your code is always the best it can be. That being said, he wasn't promoting always writing bad code, but instead being pragmatic and conscious of cost of writing "good code now". Additionally, that you need to improve your personal skills so you can more easily talk to Product Owners and persuade them to allow you the time to move deadlines, or work on "tech debt" where needed.

[Matt Brunt fed in on Twitter](https://twitter.com/Brunty/status/921372158533742592) with a quote from [Troy Hunt][troy-hunt]:

> By all means, do your damndest to get it “right” from day one but do so with the expectation that “right” is a temporary state.

This brings home the point of the unattainable "perfect system", and that you'll be constantly chasing your want for

**Imagine praising them**

[groovy-closures]: http://groovy-lang.org/closures.html
[code-golf]: https://en.wikipedia.org/wiki/Code_golf
[troy-hunt]: https://www.troyhunt.com/your-api-versioning-is-wrong-which-is/
