# Shit I should remember about programming

## Dependency Injection allows for "loose-coupling". 

- Inject the interface, not the class. In Java, if you're importing stuff into your classes that ends with "Impl", you do not understand dependency injection or IOC. 

## Knowing when to use a factory

> A factory is merely an easily accessible method that knows everything necessary to create the right object for a given situation. Factories allow you to isolate conditionals that would otherwise be duplicated in many places. If creating the right object requires a conditional, this should happen in a "factory."
>
> Sandi Metz - https://www.sandimetz.com/blog/2018/21/what-does-oo-afford

## Understand the Affordance Principle of OOP

> Large, condition-laden classes reveal failures of the OO mindset. Conditionals exist for a reason. Many times the reason is a *concept or idea* that could have been modeled as a real thing within the virtual world of your app. 
>
> The OO mindset interprets the *bodies of the branches* of these "type"-switching conditionals as pleas for you to create objects that polymorphically play a common role.
>
> The OO mindset understands the *switching logic* of these conditionals to be a petition for you to isolate object creation in a factory.
>
> And the OO mindset regards the mere *presence of a type-switching conditional* as a heartfelt request that you replace the entire thing with a simple message sent to an injected, factory-created, role-playing object.
>
> This is what OO affords. It wants you to replace your procedural monoliths with collections of small, independent, collaborative objects. The existence of a large, condition-laden class signals that the procedural code has failed you. When you see such an object, it's time to change mindsets
>
> - Sandi Metz - https://www.sandimetz.com/blog/2018/21/what-does-oo-afford

## Methods are Affordances, Not Abilities

> The fundamental misunderstanding here is thinking that methods are *things an object can do.*
>
> If you believe that the methods on an object represent the *abilities* of that object, then of course an `Announcement` having a `broadcast()` method sounds silly.
>
> But what if methods weren't the things *an object* could do? What if they were the things *you could do* with that object?
>
> If methods were the actions an object [afforded](https://en.wiktionary.org/wiki/affordance) us, then it would make perfect sense to be able to `broadcast()` an `Announcement`, wouldn't it?
>
> - Adam Wathan - [https://adamwathan.me/2017/01/24/methods-are-affordances-not-abilities/](https://adamwathan.me/2017/01/24/methods-are-affordances-not-abilities/)