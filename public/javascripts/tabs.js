/**
 * @author Ryan Johnson <http://syntacticx.com/>
 * @copyright 2008 PersonalGrid Corporation <http://personalgrid.com/>
 * @package LivePipe UI
 * @license MIT
 * @url http://livepipe.net/control/tabs
 * @require prototype.js, livepipe.js
 */

/*global window, document, Prototype, $, $A, $H, $break, Class, Element, Event, Control */

if(typeof(Prototype) == "undefined") {
    throw "Control.Tabs requires Prototype to be loaded."; }
if(typeof(Object.Event) == "undefined") {
    throw "Control.Tabs requires Object.Event to be loaded."; }

Control.Tabs = Class.create({
    initialize: function(tab_list_container,options){
        if(!$(tab_list_container)) {
            throw "Control.Tabs could not find the element: " + tab_list_container; }
        this.activeContainer = false;
        this.activeLink = false;
        this.containers = $H({});
        this.links = [];
        Control.Tabs.instances.push(this);
        this.options = {
            beforeChange: Prototype.emptyFunction,
            afterChange: Prototype.emptyFunction,
            hover: false,
            linkSelector: 'li a',
            setClassOnContainer: false,
            activeClassName: 'active',
            defaultTab: 'first',
            autoLinkExternal: true,
            targetRegExp: /#(.+)$/,
            showFunction: Element.show,
            hideFunction: Element.hide
        };
        Object.extend(this.options,options || {});
        (typeof(this.options.linkSelector == 'string') ? 
            $(tab_list_container).select(this.options.linkSelector) : 
            this.options.linkSelector($(tab_list_container))
        ).findAll(function(link){
            return (/^#/).exec((Prototype.Browser.WebKit ? decodeURIComponent(link.href) : link.href).replace(window.location.href.split('#')[0],''));
        }).each(function(link){
            this.addTab(link);
        }.bind(this));
        this.containers.values().each(Element.hide);
        if(this.options.defaultTab == 'first') {
            this.setActiveTab(this.links.first());
        } else if(this.options.defaultTab == 'last') {
            this.setActiveTab(this.links.last());
        } else {
            this.setActiveTab(this.options.defaultTab); }
        var targets = this.options.targetRegExp.exec(window.location);
        if(targets && targets[1]){
            targets[1].split(',').each(function(target){
                this.setActiveTab(this.links.find(function(link){
                    return link.key == target;
                }));
            }.bind(this));
        }
        if(this.options.autoLinkExternal){
            $A(document.getElementsByTagName('a')).each(function(a){
                if(!this.links.include(a)){
                    var clean_href = a.href.replace(window.location.href.split('#')[0],'');
                    if(clean_href.substring(0,1) == '#'){
                        if(this.containers.keys().include(clean_href.substring(1))){
                            $(a).observe('click',function(event,clean_href){
                                this.setActiveTab(clean_href.substring(1));
                            }.bindAsEventListener(this,clean_href));
                        }
                    }
                }
            }.bind(this));
        }
    },
    addTab: function(link){
        this.links.push(link);
        link.key = link.getAttribute('href').replace(window.location.href.split('#')[0],'').split('#').last().replace(/#/,'');
        var container = $(link.key);
        if(!container) {
            throw "Control.Tabs: #" + link.key + " was not found on the page."; }
        this.containers.set(link.key,container);
        link[this.options.hover ? 'onmouseover' : 'onclick'] = function(link){
            if(window.event) {
                Event.stop(window.event); }
            this.setActiveTab(link);
            return false;
        }.bind(this,link);
    },
    setActiveTab: function(link){
        if(!link && typeof(link) == 'undefined') {
            return; }
        if(typeof(link) == 'string'){
            this.setActiveTab(this.links.find(function(_link){
                return _link.key == link;
            }));
        }else if(typeof(link) == 'number'){
            this.setActiveTab(this.links[link]);
        }else{
            if(this.notify('beforeChange',this.activeContainer,this.containers.get(link.key)) === false) {
                return; }
            if(this.activeContainer) {
                this.options.hideFunction(this.activeContainer); }
            this.links.each(function(item){
                (this.options.setClassOnContainer ? $(item.parentNode) : item).removeClassName(this.options.activeClassName);
            }.bind(this));
            (this.options.setClassOnContainer ? $(link.parentNode) : link).addClassName(this.options.activeClassName);
            this.activeContainer = this.containers.get(link.key);
            this.activeLink = link;
            this.options.showFunction(this.containers.get(link.key));
            this.notify('afterChange',this.containers.get(link.key));
        }
    },
    next: function(){
        this.links.each(function(link,i){
            if(this.activeLink == link && this.links[i + 1]){
                this.setActiveTab(this.links[i + 1]);
                throw $break;
            }
        }.bind(this));
    },
    previous: function(){
        this.links.each(function(link,i){
            if(this.activeLink == link && this.links[i - 1]){
                this.setActiveTab(this.links[i - 1]);
                throw $break;
            }
        }.bind(this));
    },
    first: function(){
        this.setActiveTab(this.links.first());
    },
    last: function(){
        this.setActiveTab(this.links.last());
    }
});
Object.extend(Control.Tabs,{
    instances: [],
    findByTabId: function(id){
        return Control.Tabs.instances.find(function(tab){
            return tab.links.find(function(link){
                return link.key == id;
            });
        });
    }
});
Object.Event.extend(Control.Tabs);
