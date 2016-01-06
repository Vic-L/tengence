var TenderTabs = React.createClass({ 
  getPastWatchedTenders: function() {
    $('#select_all').prop('checked', false);
    this.props.getTenders('/api/v1/watched_tenders?table=PastTender', document.getElementById('query-field').value);
  },
  getCurrentWatchedTenders: function() {
    $('#select_all').prop('checked', false);
    this.props.getTenders('/api/v1/watched_tenders?table=CurrentTender', document.getElementById('query-field').value);
  },
  render: function(){
    return (
      <div className="row">
        <div className="small-12 column">
          <ul className="tabs" data-tab=''>
            <li className="active tab-title">
              <a href="" onClick={this.getCurrentWatchedTenders} >Current Tenders</a>
            </li>
            <li className="tab-title">
              <a href="" onClick={this.getPastWatchedTenders}>Past Tenders</a>
            </li>
          </ul>
        </div>
      </div>
    );
  }
});