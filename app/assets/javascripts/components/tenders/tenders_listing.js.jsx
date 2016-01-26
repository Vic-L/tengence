var TendersListing = React.createClass({
    // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null, url: this.props.url, keywords: this.props.keywords, sort: 'newest'};
  },
  componentDidMount: function() {
    this.getTenders(this.state.url);
  },
  getTenders: function(url, page, table, query, keywords, sort){
    // console.log(url);
    // console.log(query);
    // console.log(keywords);
    // console.log(sort);
    var uri = new URI(url);
    var params = URI.parseQuery(uri.query());
    var path = new URI(uri.path());
    if (uri.hasQuery('page')) path.addQuery('page',params.page);
    if (uri.hasQuery('table')) path.addQuery('table',params.table);
    var finalTable,finalPage,finalQuery,finalKeywords,finalSort;
    params.page != null ? finalPage = params.page : finalPage = page;
    params.table != null ? finalTable = params.table : finalTable = table;
    params.query != null ? finalQuery = params.query : finalQuery = query;
    params.keywords != null ? finalKeywords = params.keywords : finalKeywords = keywords;
    params.sort != null ? finalSort = params.sort : finalSort = sort;
    // console.log(finalQuery);
    // console.log(finalKeywords);
    // console.log(finalSort);
    Tengence.ReactFunctions.getTenders(this, path.toString(), finalTable, finalPage, finalQuery, finalKeywords, finalSort);
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
            return <p>These are tenders that have been closed, awarded and/or cancelled. You can no longer apply for these tenders.<br/><br/>We have included these tenders here for your reference!<br/><br/>NOTE: Past tenders with closing date more than 1 month ago will be archived and will not be displayed.</p>;
          case 'watched_tenders':
            return <p>Did you know that you can add Tenders to your watch list? The watchlist is your personalized list of Tenders that you are interested in!<br/><br/>Easily add or remove Tenders by clicking the "Watch" or "Unwatch" button.<br/><br/>PS: All Tenders sent to you via the daily email notification are automatically added to your watchlist.<br/><br/>NOTE: Past tenders with closing date more than 1 month ago will automatically be unwatched from your watchlist.</p>
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
      tenderTabs = <TenderTabs getTenders={this.getTenders} url={this.state.url} />;
      tenderSearchForm = <TendersSearch getTenders={this.getTenders} url={this.state.url}/>;
      tenderResults = <WatchedTendersResults sort={this.state.sort} url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} massDestroyTenders={this.massDestroyTenders} />;
    } else if (this.isKeywordsTendersPage()) {
      tenderKeywords = <KeywordsTendersForm updateKeywords={this.updateKeywords} getTenders={this.getTenders} keywords={this.state.keywords}/>;
      tenderResults = <GenericTendersResults sort={this.state.sort} url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} />;
    } else {
      tenderSearchForm = <TendersSearch getTenders={this.getTenders} url={this.state.url}/>;
      tenderResults = <GenericTendersResults sort={this.state.sort} url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} parentComponent={this} />;
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