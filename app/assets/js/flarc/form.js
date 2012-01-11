


$.widget("ui.form", {
 _init: function() {
   var object = this;
   var form = this.element;
   var inputs = form.find("input , select ,textarea");

    form.find("fieldset").addClass("ui-widget-content");
    form.find("legend").addClass("ui-widget-header ui-corner-all");
    form.addClass("ui-widget");

    $.each(inputs,function(){
    $(this).addClass('ui-state-default ui-corner-all');
    $(this).wrap("<label />");

    if($(this).is(":reset ,:submit"))
      object.buttons(this);
//    else if($(this).is(":checkbox"))
//      object.checkboxes(this);
    else if($(this).is("input[type='text']")||$(this).is("textarea")||$(this).is("input[type='password']"))
      object.textelements(this);
    else if($(this).is(":radio"))
      object.radio(this);
//    else if($(this).is("select"))
//      object.selector(this);

    if($(this).hasClass("date"))
      $(this).datepicker();

    });
   },
 textelements:function(element){
  $(element).bind({
    focusin: function() {
     $(this).toggleClass('ui-state-focus');
     },
     focusout: function() {
      $(this).toggleClass('ui-state-focus');
     }
    });
   },
 buttons:function(element)
 {
  if($(element).is(":submit"))
  {
    $(element).addClass("ui-priority-primary ui-corner-all ui-state-disabled hover");
   $(element).bind("click",function(event)
     {
       event.preventDefault();
     });
  }
  else if($(element).is(":reset"))
  $(element).addClass("ui-priority-secondary ui-corner-all hover");
  $(element).bind('mousedown mouseup', function() {
     $(this).toggleClass('ui-state-active');
     }
    );
 },

 checkboxes:function(element){
  $(element).parent("label").after("<span />");
  var parent =  $(element).parent("label").next();
   $(element).addClass("ui-helper-hidden");
    parent.css({width:16,height:16,display:"block"});

     parent.wrap("<span class='ui-state-default ui-corner-all' style='display:inline-block;width:16px;height:16px;margin-right:5px;'/>");

   parent.parent().addClass('hover');

   parent.parent("span").click(function(event){
         $(this).toggleClass("ui-state-active");
         parent.toggleClass("ui-icon ui-icon-check");
        $(element).click();
        });
   },
 radio:function(element){
     $(element).parent("label").after("<span />");
  var parent =  $(element).parent("label").next();
   $(element).addClass("ui-helper-hidden");
   parent.addClass("ui-icon ui-icon-radio-off");
     parent.wrap("<span class='ui-state-default ui-corner-all' style='display:inline-block;width:16px;height:16px;margin-right:5px;'/>");

   parent.parent().addClass('hover');

   parent.parent("span").click(function(event){
         $(this).toggleClass("ui-state-active");
         parent.toggleClass("ui-icon-radio-off ui-icon-bullet");
        $(element).click();
        });
   },
   selector:function(element){
     var parent = $(element).parent();
     parent.css({"display":"inline-block",width:140,height:21}).addClass("ui-state-default ui-corner-all");
      $(element).addClass("ui-helper-hidden");
     parent.append("<span id='labeltext' style='float:left;'></span><span style='float:right;display:inline-block' class='ui-icon ui-icon-triangle-1-s' ></span>");
     parent.after("<ul class=' ui-helper-reset ui-widget-content ui-helper-hidden' style='position:absolute;z-index:50;width:140px;' ></ul>");
     $.each($(element).find("option"),function(){
                        $(parent).next("ul").append("<li class='hover'>"+$(this).html()+"</li>");
                         });
     $(parent).next("ul").find("li").click(function(){ $("#labeltext").html($(this).html());
       $(element).val($(this).html());
     });

     $(parent).click(function(event){ $(this).next().slideToggle('fast');
       event.preventDefault();
     });
    }
 });

