var TenderTabs = React.createClass({ 
  getPastWatchedTenders: function() {
    $('#select_all').prop('checked', false);
    var urlFragments = Tengence.ReactFunctions.dissectUrl(this.props.url);
    this.props.getTenders(urlFragments.path, urlFragments.page, 'PastTender', urlFragments.query, urlFragments.keywords, urlFragments.sortOrder);
  },
  getCurrentWatchedTenders: function() {
    $('#select_all').prop('checked', false);
    var urlFragments = Tengence.ReactFunctions.dissectUrl(this.props.url);
    this.props.getTenders(urlFragments.path, urlFragments.page, 'CurrentTender', urlFragments.query, urlFragments.keywords, urlFragments.sortOrder);
  },
  getTabClasses: function(url){
    var currentTable, pastTable;
    var uri = new URI(this.props.url);
    var params = URI.parseQuery(uri.query());
    if (uri.hasQuery('table')){
      if (params.table === 'CurrentTender') {
        currentTable = 'active tab-title';
        pastTable = 'tab-title';
      } else {
        currentTable = 'tab-title';
        pastTable = 'active tab-title';
      }
    } else {
      currentTable = 'active tab-title';
      pastTable = 'tab-title';
    }
    return [currentTable,pastTable];
  },
  render: function(){
    var tabClasses = this.getTabClasses(this.props.url);
    return (
      <div className="row">
        <div className="small-12 column">
          <ul className="tabs" data-tab=''>
            <li className={tabClasses[0]}>
              <a href="" onClick={this.getCurrentWatchedTenders} >Current Tenders</a>
            </li>
            <li className={tabClasses[1]}>
              <a href="" onClick={this.getPastWatchedTenders}>Past Tenders</a>
            </li>
          </ul>
        </div>
      </div>
    );
  }
});