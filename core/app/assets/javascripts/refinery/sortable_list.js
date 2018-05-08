var create_sortable_list = function(options){
    ordered_list = {
        initialised: false
        , init: function(options) {
            if(!this.initialised){
                this.update_url = options.update_url;
                this.sortable_list = $(options.sortable_list);
                this.tree = options.tree;
                this.replaceContentsAfterUpdate = options.replaceContentsAfterUpdate;

                //setup dom
                this.div_with_list_and_actions = this.sortable_list.parents().filter(function(index) {
                    return ($(this).children("#actions").length > 0);
                });
                this.actions = $("#actions",this.div_with_list_and_actions);
                this.reorder_action = $('#reorder_action',this.actions);
                this.reorder_action_done = $('#reorder_action_done',this.actions);


                this.sortable_list.addClass("sortable_list");
                this.reorder_action.click($.proxy(this.enable_reordering, {list: this}));
                this.reorder_action_done.click($.proxy(this.disable_reordering, {list: this}));

                if(this.tree == false){
                    this.sortable_list.find('li').addClass('no-nest');
                }

                this.sortable_list.nestedSortable($.extend({
                    listType: 'ul',
                    disableNesting: 'no-nest',
                    forcePlaceholderSize: true,
                    handle: this.tree ? 'div' : null,
                    items: 'li',
                    opacity: .6,
                    placeholder: 'placeholder',
                    tabSize: 25,
                    tolerance: 'pointer',
                    toleranceElement: this.tree ? '> div' : null,
                    disabled: true,
                    start: function () {},
                    change: $.proxy(this.change, {list: this}),
                    stop: $.proxy(this.stop, {list: this})
                }, options));
                if (this.tree) {
                    this.reset_branch_classes(this.sortable_list);
                } else {
                    this.reset_on_off_classes(this.sortable_list);
                }
                this.initialised = true;
            }
            return this;
        }
        , stop: function() {
            this.list.reset_classes();
        }
        , change: function() {
            if (this.list.tree) {
                this.list.reset_branch_classes(this.list.sortable_list)
            }
        }
        , reset_classes: function(){
            if (this.tree) {
                this.reset_branch_classes(this.sortable_list);
                this.reset_icon_classes(this.sortable_list);
            } else {
                this.reset_on_off_classes(this.sortable_list);
            }
        }
        , reset_on_off_classes: function(ul) {
            $("> li", ul).each(function(i, li) {
                $(li).removeClass('on off on-hover').addClass(i % 2 === 0 ? 'on' : 'off');
            });
        }

        , reset_branch_classes: function (ul) {
            $("li.ui-sortable-helper", this).removeClass("record").removeClass("branch_start").removeClass("branch_end");
            $("li", ul).removeClass("branch_start").removeClass("branch_end");

            $("> li:first", ul).addClass("branch_start");
            $("> li:last", ul).addClass("branch_end");

            var nested_ul = $("ul", ul);
            $("> li:last", nested_ul).addClass("branch_end");
        }

        , reset_icon_classes: function(ul) {
            $('li', ul).each(function() {
                var $li   = $(this);
                var $icon = $li.find('.icon:first');

                if ($li.find('ul li').size() > 0) {
                    $icon.addClass('toggle expanded');
                }
                else if ($icon.hasClass('expanded')){
                    $icon.removeClass('toggle expanded');
                }
            });
        }

        , enable_reordering: function(e) {
            if(e) { e.preventDefault(); }
            this.list.sortable_list.addClass("reordering");
            $('.actions', this.list.sortable_list).fadeTo(0, 0.3);
            this.list.div_with_list_and_actions.parents().siblings('div').fadeTo(0, 0.3);
            $('*:not("#reorder_action_done, #reorder_action")', this.list.actions).not(this.list.reorder_action_done.parents('li, ul, div')).fadeTo(0, 0.55);
            this.list.sortable_list.nestedSortable("enable");
            this.list.reorder_action.css('display', 'none');
            this.list.reorder_action_done.css('display', 'block');
        }
        , disable_reordering: function(e){
            if(e) { e.preventDefault(); }

            if(this.list.reorder_action_done.hasClass('loading')){ return false; }

            this.list.reorder_action_done.addClass('loading');
            this.list.sortable_list.nestedSortable("disable");
            this.list.sortable_list.removeClass("reordering");

            if (this.list.update_url !== null) {
                var serialized = this.list.sortable_list.serializelist();

                $.post(this.list.update_url, serialized, $.proxy(this.list.restore_controls,{list: this.list}));
            } else {
                $.proxy(this.list.restore_controls,{list: this.list})();
            }
        }

        , restore_controls: function(e) {
            this.list.sortable_list.removeClass('reordering');
            $('.actions',this.list.sortable_list).fadeTo(0, 1);
            this.list.div_with_list_and_actions.parents().siblings('div').fadeTo(0,1);
            $('*:not("#reorder_action_done, #reorder_action")',this.list.actions).not($('#reorder_action_done').parents('li, ul, div')).fadeTo(0, 1);
            this.list.reorder_action_done.hide().removeClass('loading');
            this.list.reorder_action.show();
            if (this.list.replaceContentsAfterUpdate) {
                this.list.sortable_list.children().remove();
                this.list.sortable_list.append($(e).children());
                this.list.reset_classes();
            }
        }
    }
    ordered_list.init(options);
    return ordered_list;
};
