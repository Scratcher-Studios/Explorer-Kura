(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[85,719],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return u},kt:function(){return m}});var r=n(67294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function l(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?l(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):l(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},l=Object.keys(e);for(r=0;r<l.length;r++)n=l[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(r=0;r<l.length;r++)n=l[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var i=r.createContext({}),s=function(e){var t=r.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(i.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,l=e.originalType,i=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),d=s(n),m=a,f=d["".concat(i,".").concat(m)]||d[m]||p[m]||l;return n?r.createElement(f,o(o({ref:t},u),{},{components:n})):r.createElement(f,o({ref:t},u))}));function m(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var l=n.length,o=new Array(l);o[0]=d;var c={};for(var i in t)hasOwnProperty.call(t,i)&&(c[i]=t[i]);c.originalType=e,c.mdxType="string"==typeof e?e:a,o[1]=c;for(var s=2;s<l;s++)o[s]=n[s];return r.createElement.apply(null,o)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},39649:function(e,t,n){"use strict";n.d(t,{Z:function(){return m}});var r=n(63366),a=n(87462),l=n(67294),o=n(86010),c=n(95999),i=n(32822),s="anchorWithStickyNavbar_31ik",u="anchorWithHideOnScrollNavbar_3R7-",p=["id"],d=function(e){var t=Object.assign({},e);return l.createElement("header",null,l.createElement("h1",(0,a.Z)({},t,{id:void 0}),t.children))},m=function(e){return"h1"===e?d:(t=e,function(e){var n,d=e.id,m=(0,r.Z)(e,p),f=(0,i.LU)().navbar.hideOnScroll;return d?l.createElement(t,(0,a.Z)({},m,{className:(0,o.Z)("anchor",(n={},n[u]=f,n[s]=!f,n)),id:d}),m.children,l.createElement("a",{"aria-hidden":"true",className:"hash-link",href:"#"+d,title:(0,c.I)({id:"theme.common.headingLinkTitle",message:"Direct link to heading",description:"Title for link to heading"})},"\u200b")):l.createElement(t,m)});var t}},4083:function(e,t,n){"use strict";n.r(t),n.d(t,{default:function(){return q}});var r=n(67294),a=n(86010),l=n(97890),o=n(3905),c=n(87462),i=n(63366),s=n(12859),u=n(39960),p={plain:{backgroundColor:"#2a2734",color:"#9a86fd"},styles:[{types:["comment","prolog","doctype","cdata","punctuation"],style:{color:"#6c6783"}},{types:["namespace"],style:{opacity:.7}},{types:["tag","operator","number"],style:{color:"#e09142"}},{types:["property","function"],style:{color:"#9a86fd"}},{types:["tag-id","selector","atrule-id"],style:{color:"#eeebff"}},{types:["attr-name"],style:{color:"#c4b9fe"}},{types:["boolean","string","entity","url","attr-value","keyword","control","directive","unit","statement","regex","at-rule","placeholder","variable"],style:{color:"#ffcc99"}},{types:["deleted"],style:{textDecorationLine:"line-through"}},{types:["inserted"],style:{textDecorationLine:"underline"}},{types:["italic"],style:{fontStyle:"italic"}},{types:["important","bold"],style:{fontWeight:"bold"}},{types:["important"],style:{color:"#c4b9fe"}}]},d={Prism:n(87410).default,theme:p};function m(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function f(){return f=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var n=arguments[t];for(var r in n)Object.prototype.hasOwnProperty.call(n,r)&&(e[r]=n[r])}return e},f.apply(this,arguments)}var h=/\r\n|\r|\n/,y=function(e){0===e.length?e.push({types:["plain"],content:"\n",empty:!0}):1===e.length&&""===e[0].content&&(e[0].content="\n",e[0].empty=!0)},g=function(e,t){var n=e.length;return n>0&&e[n-1]===t?e:e.concat(t)},v=function(e,t){var n=e.plain,r=Object.create(null),a=e.styles.reduce((function(e,n){var r=n.languages,a=n.style;return r&&!r.includes(t)||n.types.forEach((function(t){var n=f({},e[t],a);e[t]=n})),e}),r);return a.root=n,a.plain=f({},n,{backgroundColor:null}),a};function b(e,t){var n={};for(var r in e)Object.prototype.hasOwnProperty.call(e,r)&&-1===t.indexOf(r)&&(n[r]=e[r]);return n}var k=function(e){function t(){for(var t=this,n=[],r=arguments.length;r--;)n[r]=arguments[r];e.apply(this,n),m(this,"getThemeDict",(function(e){if(void 0!==t.themeDict&&e.theme===t.prevTheme&&e.language===t.prevLanguage)return t.themeDict;t.prevTheme=e.theme,t.prevLanguage=e.language;var n=e.theme?v(e.theme,e.language):void 0;return t.themeDict=n})),m(this,"getLineProps",(function(e){var n=e.key,r=e.className,a=e.style,l=f({},b(e,["key","className","style","line"]),{className:"token-line",style:void 0,key:void 0}),o=t.getThemeDict(t.props);return void 0!==o&&(l.style=o.plain),void 0!==a&&(l.style=void 0!==l.style?f({},l.style,a):a),void 0!==n&&(l.key=n),r&&(l.className+=" "+r),l})),m(this,"getStyleForToken",(function(e){var n=e.types,r=e.empty,a=n.length,l=t.getThemeDict(t.props);if(void 0!==l){if(1===a&&"plain"===n[0])return r?{display:"inline-block"}:void 0;if(1===a&&!r)return l[n[0]];var o=r?{display:"inline-block"}:{},c=n.map((function(e){return l[e]}));return Object.assign.apply(Object,[o].concat(c))}})),m(this,"getTokenProps",(function(e){var n=e.key,r=e.className,a=e.style,l=e.token,o=f({},b(e,["key","className","style","token"]),{className:"token "+l.types.join(" "),children:l.content,style:t.getStyleForToken(l),key:void 0});return void 0!==a&&(o.style=void 0!==o.style?f({},o.style,a):a),void 0!==n&&(o.key=n),r&&(o.className+=" "+r),o})),m(this,"tokenize",(function(e,t,n,r){var a={code:t,grammar:n,language:r,tokens:[]};e.hooks.run("before-tokenize",a);var l=a.tokens=e.tokenize(a.code,a.grammar,a.language);return e.hooks.run("after-tokenize",a),l}))}return e&&(t.__proto__=e),t.prototype=Object.create(e&&e.prototype),t.prototype.constructor=t,t.prototype.render=function(){var e=this.props,t=e.Prism,n=e.language,r=e.code,a=e.children,l=this.getThemeDict(this.props),o=t.languages[n];return a({tokens:function(e){for(var t=[[]],n=[e],r=[0],a=[e.length],l=0,o=0,c=[],i=[c];o>-1;){for(;(l=r[o]++)<a[o];){var s=void 0,u=t[o],p=n[o][l];if("string"==typeof p?(u=o>0?u:["plain"],s=p):(u=g(u,p.type),p.alias&&(u=g(u,p.alias)),s=p.content),"string"==typeof s){var d=s.split(h),m=d.length;c.push({types:u,content:d[0]});for(var f=1;f<m;f++)y(c),i.push(c=[]),c.push({types:u,content:d[f]})}else o++,t.push(u),n.push(s),r.push(0),a.push(s.length)}o--,t.pop(),n.pop(),r.pop(),a.pop()}return y(c),i}(void 0!==o?this.tokenize(t,r,o,n):[r]),className:"prism-code language-"+n,style:void 0!==l?l.root:{},getLineProps:this.getLineProps,getTokenProps:this.getTokenProps})},t}(r.Component),E=k;var N=n(87594),x=n.n(N),j={plain:{color:"#bfc7d5",backgroundColor:"#292d3e"},styles:[{types:["comment"],style:{color:"rgb(105, 112, 152)",fontStyle:"italic"}},{types:["string","inserted"],style:{color:"rgb(195, 232, 141)"}},{types:["number"],style:{color:"rgb(247, 140, 108)"}},{types:["builtin","char","constant","function"],style:{color:"rgb(130, 170, 255)"}},{types:["punctuation","selector"],style:{color:"rgb(199, 146, 234)"}},{types:["variable"],style:{color:"rgb(191, 199, 213)"}},{types:["class-name","attr-name"],style:{color:"rgb(255, 203, 107)"}},{types:["tag","deleted"],style:{color:"rgb(255, 85, 114)"}},{types:["operator"],style:{color:"rgb(137, 221, 255)"}},{types:["boolean"],style:{color:"rgb(255, 88, 116)"}},{types:["keyword"],style:{fontStyle:"italic"}},{types:["doctype"],style:{color:"rgb(199, 146, 234)",fontStyle:"italic"}},{types:["namespace"],style:{color:"rgb(178, 204, 214)"}},{types:["url"],style:{color:"rgb(221, 221, 221)"}}]},O=n(85350),C=n(32822),Z=function(){var e=(0,C.LU)().prism,t=(0,O.Z)().isDarkTheme,n=e.theme||j,r=e.darkTheme||n;return t?r:n},_=n(95999),T="codeBlockContainer_K1bP",P="codeBlockContent_hGly",S="codeBlockTitle_eoMF",L="codeBlock_23N8",w="copyButton_Ue-o",D="codeBlockLines_39YC",B=/{([\d,-]+)}/,A=["js","jsBlock","jsx","python","html"],H={js:{start:"\\/\\/",end:""},jsBlock:{start:"\\/\\*",end:"\\*\\/"},jsx:{start:"\\{\\s*\\/\\*",end:"\\*\\/\\s*\\}"},python:{start:"#",end:""},html:{start:"\x3c!--",end:"--\x3e"}},I=["highlight-next-line","highlight-start","highlight-end"],R=function(e){void 0===e&&(e=A);var t=e.map((function(e){var t=H[e],n=t.start,r=t.end;return"(?:"+n+"\\s*("+I.join("|")+")\\s*"+r+")"})).join("|");return new RegExp("^\\s*(?:"+t+")\\s*$")};function M(e){var t=e.children,n=e.className,l=e.metastring,o=e.title,i=(0,C.LU)().prism,s=(0,r.useState)(!1),u=s[0],p=s[1],m=(0,r.useState)(!1),f=m[0],h=m[1];(0,r.useEffect)((function(){h(!0)}),[]);var y=(0,C.bc)(l)||o,g=(0,r.useRef)(null),v=[],b=Z(),k=Array.isArray(t)?t.join(""):t;if(l&&B.test(l)){var N=l.match(B)[1];v=x()(N).filter((function(e){return e>0}))}var j=null==n?void 0:n.split(" ").find((function(e){return e.startsWith("language-")})),O=null==j?void 0:j.replace(/language-/,"");!O&&i.defaultLanguage&&(O=i.defaultLanguage);var A=k.replace(/\n$/,"");if(0===v.length&&void 0!==O){for(var H,I="",M=function(e){switch(e){case"js":case"javascript":case"ts":case"typescript":return R(["js","jsBlock"]);case"jsx":case"tsx":return R(["js","jsBlock","jsx"]);case"html":return R(["js","jsBlock","html"]);case"python":case"py":return R(["python"]);default:return R()}}(O),F=k.replace(/\n$/,"").split("\n"),z=0;z<F.length;){var U=z+1,V=F[z].match(M);if(null!==V){switch(V.slice(1).reduce((function(e,t){return e||t}),void 0)){case"highlight-next-line":I+=U+",";break;case"highlight-start":H=U;break;case"highlight-end":I+=H+"-"+(U-1)+","}F.splice(z,1)}else z+=1}v=x()(I),A=F.join("\n")}var W=function(){!function(e,{target:t=document.body}={}){const n=document.createElement("textarea"),r=document.activeElement;n.value=e,n.setAttribute("readonly",""),n.style.contain="strict",n.style.position="absolute",n.style.left="-9999px",n.style.fontSize="12pt";const a=document.getSelection();let l=!1;a.rangeCount>0&&(l=a.getRangeAt(0)),t.append(n),n.select(),n.selectionStart=0,n.selectionEnd=e.length;let o=!1;try{o=document.execCommand("copy")}catch{}n.remove(),l&&(a.removeAllRanges(),a.addRange(l)),r&&r.focus()}(A),p(!0),setTimeout((function(){return p(!1)}),2e3)};return r.createElement(E,(0,c.Z)({},d,{key:String(f),theme:b,code:A,language:O}),(function(e){var t=e.className,l=e.style,o=e.tokens,i=e.getLineProps,s=e.getTokenProps;return r.createElement("div",{className:(0,a.Z)(T,null==n?void 0:n.replace(/language-[^ ]+/,""))},y&&r.createElement("div",{style:l,className:S},y),r.createElement("div",{className:(0,a.Z)(P,O)},r.createElement("pre",{tabIndex:0,className:(0,a.Z)(t,L,"thin-scrollbar"),style:l},r.createElement("code",{className:D},o.map((function(e,t){1===e.length&&"\n"===e[0].content&&(e[0].content="");var n=i({line:e,key:t});return v.includes(t+1)&&(n.className+=" docusaurus-highlight-code-line"),r.createElement("span",(0,c.Z)({key:t},n),e.map((function(e,t){return r.createElement("span",(0,c.Z)({key:t},s({token:e,key:t})))})),r.createElement("br",null))})))),r.createElement("button",{ref:g,type:"button","aria-label":(0,_.I)({id:"theme.CodeBlock.copyButtonAriaLabel",message:"Copy code to clipboard",description:"The ARIA label for copy code blocks button"}),className:(0,a.Z)(w,"clean-btn"),onClick:W},u?r.createElement(_.Z,{id:"theme.CodeBlock.copied",description:"The copied button label on code blocks"},"Copied"):r.createElement(_.Z,{id:"theme.CodeBlock.copy",description:"The copy button label on code blocks"},"Copy"))))}))}var F=n(39649),z="details_1VDD";function U(e){var t=Object.assign({},e);return r.createElement(C.PO,(0,c.Z)({},t,{className:(0,a.Z)("alert alert--info",z,t.className)}))}var V=["mdxType","originalType"];var W={head:function(e){var t=r.Children.map(e.children,(function(e){return function(e){var t,n;if(null!=e&&null!=(t=e.props)&&t.mdxType&&null!=e&&null!=(n=e.props)&&n.originalType){var a=e.props,l=(a.mdxType,a.originalType,(0,i.Z)(a,V));return r.createElement(e.props.originalType,l)}return e}(e)}));return r.createElement(s.Z,e,t)},code:function(e){var t=e.children;return(0,r.isValidElement)(t)?t:t.includes("\n")?r.createElement(M,e):r.createElement("code",e)},a:function(e){return r.createElement(u.Z,e)},pre:function(e){var t,n=e.children;return(0,r.isValidElement)(n)&&(0,r.isValidElement)(null==n||null==(t=n.props)?void 0:t.children)?n.props.children:r.createElement(M,(0,r.isValidElement)(n)?null==n?void 0:n.props:Object.assign({},e))},details:function(e){var t=r.Children.toArray(e.children),n=t.find((function(e){var t;return"summary"===(null==e||null==(t=e.props)?void 0:t.mdxType)})),a=r.createElement(r.Fragment,null,t.filter((function(e){return e!==n})));return r.createElement(U,(0,c.Z)({},e,{summary:n}),a)},h1:(0,F.Z)("h1"),h2:(0,F.Z)("h2"),h3:(0,F.Z)("h3"),h4:(0,F.Z)("h4"),h5:(0,F.Z)("h5"),h6:(0,F.Z)("h6")},$=n(51575),K="mdxPageWrapper_3qD3";var q=function(e){var t=e.content,n=t.frontMatter,c=t.metadata,i=n.title,s=n.description,u=n.wrapperClassName,p=n.hide_table_of_contents,d=c.permalink;return r.createElement(l.Z,{title:i,description:s,permalink:d,wrapperClassName:null!=u?u:C.kM.wrapper.mdxPages,pageClassName:C.kM.page.mdxPage},r.createElement("main",{className:"container container--fluid margin-vert--lg"},r.createElement("div",{className:(0,a.Z)("row",K)},r.createElement("div",{className:(0,a.Z)("col",!p&&"col--8")},r.createElement(o.Zo,{components:W},r.createElement(t,null))),!p&&t.toc&&r.createElement("div",{className:"col col--2"},r.createElement($.Z,{toc:t.toc,minHeadingLevel:n.toc_min_heading_level,maxHeadingLevel:n.toc_max_heading_level})))))}},25002:function(e,t,n){"use strict";n.d(t,{Z:function(){return s}});var r=n(87462),a=n(63366),l=n(67294),o=n(32822),c=["toc","className","linkClassName","linkActiveClassName","minHeadingLevel","maxHeadingLevel"];function i(e){var t=e.toc,n=e.className,r=e.linkClassName,a=e.isChild;return t.length?l.createElement("ul",{className:a?void 0:n},t.map((function(e){return l.createElement("li",{key:e.id},l.createElement("a",{href:"#"+e.id,className:null!=r?r:void 0,dangerouslySetInnerHTML:{__html:e.value}}),l.createElement(i,{isChild:!0,toc:e.children,className:n,linkClassName:r}))}))):null}function s(e){var t=e.toc,n=e.className,s=void 0===n?"table-of-contents table-of-contents__left-border":n,u=e.linkClassName,p=void 0===u?"table-of-contents__link":u,d=e.linkActiveClassName,m=void 0===d?void 0:d,f=e.minHeadingLevel,h=e.maxHeadingLevel,y=(0,a.Z)(e,c),g=(0,o.LU)(),v=null!=f?f:g.tableOfContents.minHeadingLevel,b=null!=h?h:g.tableOfContents.maxHeadingLevel,k=(0,o.DA)({toc:t,minHeadingLevel:v,maxHeadingLevel:b}),E=(0,l.useMemo)((function(){if(p&&m)return{linkClassName:p,linkActiveClassName:m,minHeadingLevel:v,maxHeadingLevel:b}}),[p,m,v,b]);return(0,o.Si)(E),l.createElement(i,(0,r.Z)({toc:k,className:s,linkClassName:p},y))}},51575:function(e,t,n){"use strict";n.d(t,{Z:function(){return u}});var r=n(87462),a=n(63366),l=n(67294),o=n(86010),c=n(25002),i="tableOfContents_35-E",s=["className"];var u=function(e){var t=e.className,n=(0,a.Z)(e,s);return l.createElement("div",{className:(0,o.Z)(i,"thin-scrollbar",t)},l.createElement(c.Z,(0,r.Z)({},n,{linkClassName:"table-of-contents__link toc-highlight",linkActiveClassName:"table-of-contents__link--active"})))}},6979:function(e,t,n){"use strict";var r=n(76775),a=n(52263),l=n(28084),o=n(94184),c=n.n(o),i=n(67294);t.Z=function(e){var t=(0,i.useRef)(!1),o=(0,i.useRef)(null),s=(0,r.k6)(),u=(0,a.Z)().siteConfig,p=(void 0===u?{}:u).baseUrl;(0,i.useEffect)((function(){var e=function(e){"s"!==e.key&&"/"!==e.key||o.current&&e.srcElement===document.body&&(e.preventDefault(),o.current.focus())};return document.addEventListener("keydown",e),function(){document.removeEventListener("keydown",e)}}),[]);var d=(0,l.usePluginData)("docusaurus-lunr-search"),m=function(){t.current||(Promise.all([fetch(""+p+d.fileNames.searchDoc).then((function(e){return e.json()})),fetch(""+p+d.fileNames.lunrIndex).then((function(e){return e.json()})),Promise.all([n.e(16),n.e(245)]).then(n.bind(n,24130)),Promise.all([n.e(532),n.e(343)]).then(n.bind(n,53343))]).then((function(e){var t=e[0],n=e[1],r=e[2].default;0!==t.length&&function(e,t,n){new n({searchDocs:e,searchIndex:t,inputSelector:"#search_input_react",handleSelected:function(e,t,n){var r=p+n.url;document.createElement("a").href=r,s.push(r)}})}(t,n,r)})),t.current=!0)},f=(0,i.useCallback)((function(t){o.current.contains(t.target)||o.current.focus(),e.handleSearchBarToggle&&e.handleSearchBarToggle(!e.isSearchBarExpanded)}),[e.isSearchBarExpanded]);return i.createElement("div",{className:"navbar__search",key:"search-box"},i.createElement("span",{"aria-label":"expand searchbar",role:"button",className:c()("search-icon",{"search-icon-hidden":e.isSearchBarExpanded}),onClick:f,onKeyDown:f,tabIndex:0}),i.createElement("input",{id:"search_input_react",type:"search",placeholder:"Press S to Search...","aria-label":"Search",className:c()("navbar__search-input",{"search-bar-expanded":e.isSearchBarExpanded},{"search-bar":!e.isSearchBarExpanded}),onClick:m,onMouseOver:m,onFocus:f,onBlur:f,ref:o}))}},87594:function(e,t){function n(e){let t,n=[];for(let r of e.split(",").map((e=>e.trim())))if(/^-?\d+$/.test(r))n.push(parseInt(r,10));else if(t=r.match(/^(-?\d+)(-|\.\.\.?|\u2025|\u2026|\u22EF)(-?\d+)$/)){let[e,r,a,l]=t;if(r&&l){r=parseInt(r),l=parseInt(l);const e=r<l?1:-1;"-"!==a&&".."!==a&&"\u2025"!==a||(l+=e);for(let t=r;t!==l;t+=e)n.push(t)}}return n}t.default=n,e.exports=n}}]);