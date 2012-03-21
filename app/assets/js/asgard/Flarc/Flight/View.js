
Ext.define('Asgard.Core.Person.View', {
  extend: 'Asgard.ObjectView',
  alias: 'widget.person_view',
  tpl: [ '<tpl for=".">',
           '<div class="item asgard_object">',
             '{name.first} {name.last}<br/> ',
             '<b>{italian_fiscal_code}</b>',
           '</div>',
          '</tpl>',
  ],
  store: {
    model: 'Ygg.Core.Person',
    params: { view: 'grid' },
    remoteSort: true,
    remoteFilter: true,
  },
});

