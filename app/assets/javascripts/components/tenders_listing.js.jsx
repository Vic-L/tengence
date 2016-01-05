var TendersListing = React.createClass({
    // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null, url: this.props.url};
  },
  componentDidMount: function() {
    this.getTenders(this.state.url, null);
  },
  getTenders: function(url, query){
    this.showLoading();
    $.ajax({
      url: url,
      data: {
        query: query
      },
      method: 'GET',
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({
          pagination: data.pagination,
          tenders: data.tenders,
          results_count: data.results_count,
          url: url
        });
        // history.pushState({ url: url }, '', url.replace('/api/v1',''));
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(url, status, err.toString());
      }.bind(this),
      complete: function(xhr, status){
        this.stopLoading();
      }.bind(this)
    });
  },
  unwatchTender: function(ref_no) {
    this.showLoading();
    $.ajax({
      url: '/api/v1/watched_tenders/' + encodeURIComponent(ref_no),
      dataType: 'json',
      method: 'DELETE',
      cache: false,
      success: function(ref_no) {
        var tenders = this.state.tenders;
        for (var i = 0; i < tenders.length; i++) {
          if (tenders[i].ref_no === ref_no) {
            tenders[i].watched = false;
            break;
          }
        }
        var newTenderCount = +$('.total-count').first().text() - 1;
        this.setState({
          tenders: tenders,
          results_count: newTenderCount.toString()
        }, function(){
          $("a.watch-button[data-gtm-label='" + ref_no + "']").notify(
            "Successfully removed from watchlist", "success", 
            { position: "top" }
          );
        });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(ref_no, status, err.toString());
      }.bind(this),
      complete: function(xhr, status){
        this.stopLoading();
      }.bind(this)
    });
  },
  watchTender: function(ref_no) {
    this.showLoading();
    $.ajax({
      url: '/api/v1/watched_tenders',
      data: {
        id: ref_no
      },
      dataType: 'json',
      method: 'POST',
      cache: false,
      success: function(ref_no) {
        var tenders = this.state.tenders;
        for (var i = 0; i < tenders.length; i++) {
          if (tenders[i].ref_no === ref_no) {
            tenders[i].watched = true;
            break;
          }
        }
        var newTenderCount = +$('.total-count').first().text() + 1;
        this.setState({
          tenders: tenders,
          results_count: newTenderCount.toString()
        }, function(){
          $("a.unwatch-button[data-gtm-label='" + ref_no + "']").notify(
            "Successfully added to watchlist", "success", 
            { position: "top" }
          );
        });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(ref_no, status, err.toString());
      }.bind(this),
      complete: function(xhr, status){
        this.stopLoading();
      }.bind(this)
    });
  },
  showTender: function(ref_no) {
    this.showLoading();
    $.ajax({
      url: '/api/v1/tenders/' + encodeURIComponent(ref_no),
      dataType: 'json',
      method: 'get',
      cache: false,
      success: function(tender) {
        $('#view-more-modal').empty();
        ReactDOM.render(
          <ShowTender tender={tender}/>,
          document.getElementById('view-more-modal')
        );
        $('#view-more-modal').foundation('reveal', 'open');
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(ref_no, status, err.toString());
      }.bind(this),
      complete: function(xhr, status){
        this.stopLoading();
      }.bind(this)
    });
  },
  showLoading: function(){
    $('section#tender-results').addClass('blur');
    document.body.classList.add('loading');
  },
  stopLoading: function() {
    $('section#tender-results').removeClass('blur');
    document.body.classList.remove('loading');
  },
  getDescriptionText: function(){
    var list = ['current_tenders','past_tenders'];
    for (var i=0;i<list.length;i++) {
      if (window.location.href.indexOf(list[i]) !== -1) {
        switch(list[i]) {
          case 'current_tenders':
            return <p>These are the current live Tenders available in Singapore! We have taken the painstaking effort of collating all the Tenders into a common platform, so that you do not have to.<br/><br/>What are you waiting for! Start searching for Tenders that suits your business profile by entering in a Keyword at the search box.</p>;
          case 'past_tenders':
            return <p>These are tenders that have been closed, awarded and/or cancelled. You can no longer apply for these tenders.<br/><br/>We have included these tenders here for your reference!</p>;
          case 'watched_tenders':
            return <p>Did you know that you can add Tenders to your watch list? The watchlist is your personalized list of Tenders that you are interested in!<br/><br/>Easily add or remove Tenders by clicking the "Watch" or "Unwatch" button.<br/><br/>PS: All Tenders sent to you via the daily email notification are automatically added to your watchlist.</p>
          default:
            return "";
        }
      }
    };
  },
  render: function(){
    var tenderCount = null, tenderTabs, tenderResults;
    if (this.props.current_tenders_count != null) {
      tenderCount = <TendersCount current_tenders_count={this.props.current_tenders_count} />;
    }
    if (window.location.href.indexOf('watched_tenders') !== -1) {
      tenderTabs = <TenderTabs getTenders={this.getTenders}/>;
      tenderResults = <WatchedTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} unwatchTender={this.unwatchTender} watchTender={this.watchTender} showTender={this.showTender} />;
    } else {
      tenderResults = <GenericTendersResults url={this.state.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} tenders={this.state.tenders} unwatchTender={this.unwatchTender} watchTender={this.watchTender} showTender={this.showTender} />;
    }
    return (
      <div id='wrapper'>
        {tenderCount}
        <TendersDescription descriptionText={this.getDescriptionText()} />
        {tenderTabs}
        <TendersSearch getTenders={this.getTenders} url={this.state.url}/>
        {tenderResults}
      </div>
    );
  }
});