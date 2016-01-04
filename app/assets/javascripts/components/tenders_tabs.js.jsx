var TenderTabs = React.createClass({ 
  getPastWatchedTenders: function() {
    this.props.showLoading();
    this.props.getTenders('/api/v1/watched_tenders?table=PastTender')
  },
  getCurrentWatchedTenders: function() {
    this.props.showLoading();
    this.props.getTenders('/api/v1/watched_tenders?table=CurrentTender')
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