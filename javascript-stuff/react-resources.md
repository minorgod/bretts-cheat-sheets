# React.js Stuff

## Frameworks

### [Remix](https://remix.run/)

 If you're not already using Next.js, [try Remix first](https://remix.run/). Trust me. It was created by the same guy that created React Router (like, the official one) and it provides some very opinionated "Best Practices" to make your sites load super fast, provide as way to keep your components fully decoupled and avoid "loading spinner hell" when your app is hitting a bunch of microservices to build its UI. By default you **WILL** end up with a much nicer end user experience if you start your project with Remix than you will if you start with Next.js or most other React frameworks. You can achieve the same thing with Next.js, but you probably won't because you won't consistently build your app the right way. Remix solves all the hard problems already. Just accept that they know better, and do what they say. You should really take an hour and [watch this interview with Michael Jackson](https://www.youtube.com/watch?v=xI-OggjrKLg) to understand why this framework is so great. 

### **[Next.js](https://nextjs.org/)**

If you've ignored what I said above, then you might just be smart enough to know why you want to [use Next.js](https://nextjs.org/). Or someone told you Next.js was cool and they seemed pretty convincing. Well, it's not like Next.js is bad. But if you haven't used either Next.js or Remix, try Remix first.  

### Others

Yes, there are many other React frameworks. If you want a [giant list of awesome React resources](https://github.com/topics/awesome?q=react), check out the ["Awesome" Topic on Github](https://github.com/topics/awesome).

------

## Create React App Improvements

These packages will let you overcome the [limitations of webpack configuration in CRA](https://medium.com/@timarney/but-i-dont-wanna-eject-3e3da5826e39#.x81bb4kji). Be aware, those limitations are there for a reason, so think hard about whether you want/need to customize the webpack config used by CRA. These projects are listed in the order I would recommend you consider them. 

### Create React App 1.x Compatible

- See [React App Rewired](https://www.npmjs.com/package/react-app-rewired) below. 

### Create React App 2.x Compatible

- [React App Rewired](https://github.com/timarney/react-app-rewired) - Even though the maintainer says the project is now "lightly maintained since CRA2.0" (it was orginally made for CRA1.x), it's still probably the most widely maintained of the CRA config override projects. 

  I'm not entirely sure if this project is now fully CRA2.0 compatible, but it seems like it, so it's the first one I'd try regardless if you are using CRA1.0 or CRA2.0. 

- [Craco](https://github.com/gsoft-inc/craco) - Might actually be better than react-app-rewired, but seems less actively maintained. Despite having only hald the number of contributors as the react-app-rewired project, it has nearly as many projects using it, which seems like a good sign.

- [Rescripts](https://github.com/harrysolovay/rescripts) - Looks pretty nice, but much smaller community that appears to be fairly inactive lately. Has extensive documentation and might be better architected than the other options. Offers a middleware layer with individual "rescripts" (conceptually similar to babel plugins). The rescripts API exposes a middleware entry, so that you can track your configurations as they are transformed. It should also be noted that Rescripts is compatible with many Webpack rewires built for react-app-rewired.

- [customize-cra](https://github.com/arackaf/customize-cra) - I do not recommend you use this. It is a convenience layer on top of react-app-rewired that hasn't had a commit in 2 years. 

There are a handful of other options out there, but these are the only ones I'd consider for now. When in doubt, I like to look at the community and the momentum behind a project when deciding on which one to use, but this is not always a perfect indicator of how great a project is. 

|                   | Contrubutors | Projects Using It | Last Release | Forks | Stars | Watchers |
| ----------------- | ------------ | ----------------- | ------------ | ----- | ----- | -------- |
| react-app-rewired | 99           | 77,800            | 2/15/2022    | 402   | 8.9k  | 88       |
| craco             | 52           | 75,252            | 12/9/2021    | 425   | 5.9k  | 56       |
| customize-cra     | 38           | 37,735            | 05/28/2020   | 261   | 2.5k  | 21       |
| rescripts         | 18           | 32                | 02/18/2021   | 54    | 1.1k  | 8        |

## 

## Static Site Generators

[Gatsby](https://github.com/gatsbyjs/gatsby) - static site generator for React. [Here's](https://github.com/mui-org/material-ui/tree/master/examples/gatsby) a material-ui example for Gatsby too. 

## React UI Component Libraries

- [React Virtualized](https://bvaughn.github.io/react-virtualized/#/components/List) - If you want a big-ass, but performant scrollable list, check this out. 
- [Material-UI](https://material-ui.com/) - React components for faster and easier web development. 
  	Check out their [github repository](https://github.com/mui-org/material-ui). 
  	Also check out the [mui-org repository group](https://github.com/mui-org) at github. 
  	Build your own design system, or start with [Material Design](https://material.io/design/introduction/). 
  	Example Templates are [here](https://material-ui.com/getting-started/templates/). 
- [Blueprint](https://blueprintjs.com/) - React-based UI toolkit by Palantir Technologies. Looks very nice. 
- [KendoReact](https://www.telerik.com/kendo-react-ui/) - UI for React Developers. This is just one of many COMMERCIAL ui libraries from [Telerik](https://www.telerik.com/all-products).
- [Ant Design](https://ant.design/) - Here's their [react lib](https://ant.design/docs/react/introduce), but they also do versions for other frameworks such as Vue.js.
- [React Admin](https://marmelab.com/react-admin/) - A Web Framework for B2B applications
- [Shards](https://designrevision.com/downloads/shards-react/) - A high-quality & free React UI kit featuring a modern design system with dozens of custom components.
- [React Bootstrap](https://react-bootstrap.github.io/) - React-Bootstrap replaces the Bootstrap JavaScript. Each component has been built from scratch as a true React component, without unneeded dependencies like jQuery. As one of the oldest React libraries, React-Bootstrap has evolved and grown alongside React, making it an excellent choice as your UI foundation.
- [Argon Design System React](https://www.creative-tim.com/product/argon-design-system-react/?partner=91096) - FREE DESIGN SYSTEM FOR BOOTSTRAP 4 (REACTSTRAP)
- [React Semantic UI](https://react.semantic-ui.com/) - The official Semantic-UI-React integration
- [React Toolbox](http://react-toolbox.io/#/) - 
- [React Desktop](http://reactdesktop.js.org/) - **react-desktop** is a JavaScript library built on top of [Facebook's React](https://facebook.github.io/react/) library, which aims to bring a native desktop experience to the web, featuring many macOS Sierra and Windows 10 components. **react-desktop** works perfectly with [NW.js](http://nwjs.io/) and [Electron.js](http://electron.atom.io/), but can be used in any JavaScript powered project!
- [Onseen UI](https://onsen.io/react/) - More than 100 components are specially made for Material and Flat design, with [automatic platform detection](https://onsen.io/blog/auto-style-app-onsen/)
- [Evergreen](https://evergreen.segment.com/) - A Design System for the Web -Evergreen is a React UI Framework for building ambitious products on the web. Brought to you by [Segment](https://segment.com/).
- [ReactStrap](https://reactstrap.github.io/) - boostrap react stuff
- [ReBass](https://rebassjs.org/) - REACT PRIMITIVE UI COMPONENTS BUILT WITH STYLED SYSTEM
- [Gromett](https://v2.grommet.io/) - build responsive and accessible mobile-first projects for the web with an easy to use component library
- [Elemental UI](http://elemental-ui.com/) - A UI Toolkit for React.js Websites and Apps
- [React Suite](https://rsuitejs.com/en/) - A suite of React components, sensible UI design, and a friendly development experience.
- [Belle](http://nikgraf.github.io/belle/#/?_k=z3yf1v) - Configurable React Components with great UX
- [React MD](https://react-md.mlaursen.com/) - This project's goal is to be able to create a fully accessible material design styled website using React Components and Sass. With the separation of styles in Sass instead of inline styles, it should hopefully be easy to create custom components with the existing styles.
- [Prime](https://www.primefaces.org/#) - commercial components for most JS frameworks, including react. 

