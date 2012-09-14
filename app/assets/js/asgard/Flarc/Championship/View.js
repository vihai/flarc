
Ext.define('Asgard.Flarc.Championship.View', {
  extend: 'Asgard.ObjectView',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
    'Flarc.ChampionshipType',
    'Asgard.Flarc.Championship',
  ],
  alias: 'widget.flarc_championship_view',

  asgardObject: 'Asgard.Flarc.Championship',
  store: {
    model: 'Flarc.Championship',
    params: { view: 'grid' },
    remoteSort: true,
    remoteFilter: true,
  },
});

