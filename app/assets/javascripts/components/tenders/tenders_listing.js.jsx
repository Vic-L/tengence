var TendersListing = React.createClass({
    // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null, url: this.props.url, keywords: this.props.keywords};
  },
  componentDidMount: function() {
    this.getTenders(this.state.url, null);
  },
  getTenders: function(url, query, keywords){
    Tengence.ReactFunctions.getTenders(this, url, query, keywords);
  },
  massDestroyTenders: function(tender_ids){
    Tengence.ReactFunctions.massDestroyTenders(this,tender_ids);
  },
  isWatchedTendersPage: function(){
    if (window.location.href.indexOf('watched_tenders') === -1){
      return false;
    } else {
      return true;
    }
  },
  isKeywordsTendersPage: function(){
    if (window.location.href.indexOf('keywords_tenders') === -1){
      return false;
    } else {
      return true;
    }
  },
  getDescriptionText: function(){
    var list = ['current_tenders','past_tenders','watched_tenders','keywords_tenders'];
    for (var i=0;i<list.length;i++) {
      if (window.location.href.indexOf(list[i]) !== -1) {
        switch(list[i]) {
          case 'current_tenders':
            return <p>These are the current live Tenders available in Singapore! We have taken the painstaking effort of collating all the Tenders into a common platform, so that you do not have to.<br/><br/>What are you waiting for! Start searching for Tenders that suits your business profile by entering in a Keyword at the search box.</p>;
          case 'past_tenders':
            return <p>These are tenders that have been closed, awarded and/or cancelled. You can no longer apply for these tenders.<br/><br/>We have included these tenders here for your reference!</p>;
          case 'watched_tenders':
            return <p>Did you know that you can add Tenders to your watch list? The watchlist is your personalized list of Tenders that you are interested in!<br/><br/>Easily add or remove Tenders by clicking the "Watch" or "Unwatch" button.<br/><br/>PS: All Tenders sent to you via the daily email notification are automatically added to your watchlist.</p>
          case 'keywords_tenders':
            return <p>Setup your account by inserting some keywords for us to track so that we can send you the daily email notification. All keywords must be separated by a Comma (Keyword 1, Keyword 2). You have up to 20 keywords free!<br/><br/>Come to this section to quickly filter all the Current Tenders to your desired Keywords! Add them quickly to your watchlist if necessary.</p>
          default:
            return "";
        }
      }
    };
  },
  updateKeywords: function(keywords){
    Tengence.ReactFunctions.updateKeywords(this,keywords);
  },
  render: function(){
    var tenderCount, tenderTabs, tenderResults, tenderKeywords, tenderSearchForm;
    if (this.props.current_tenders_count != null) {
      tenderCount = <TendersCount current_tenders_count={this.props.current_tenders_count} />;
    }
    if (this.isWatchedTendersPage()){
      tenderTabs = <TenderTabs getTenders={this.getTenders}/>;
      tenderSearchForm = <TendersSearch getTenders={this.getTenders} url={this.state.url}/>;
      tenderResults = <WatchedTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} massDestroyTenders={this.massDestroyTenders} />;
    } else if (this.isKeywordsTendersPage()) {
      tenderKeywords = <KeywordsTendersForm updateKeywords={this.updateKeywords} getTenders={this.getTenders} keywords={this.state.keywords}/>;
      tenderResults = <GenericTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} />;
    } else {
      tenderSearchForm = <TendersSearch getTenders={this.getTenders} url={this.state.url}/>;
      tenderResults = <GenericTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} />;
    }
    return (
      <div id='wrapper'>
        {tenderCount}
        <TendersDescription descriptionText={this.getDescriptionText()} />
        {tenderKeywords}
        {tenderTabs}
        {tenderSearchForm}
        {tenderResults}
      </div>
    );
  }
});