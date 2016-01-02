var TendersListing = React.createClass({
    // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null};
  },
  componentDidMount: function() {
    this.getTenders(this.props.url);
  },
  getTenders: function(url){
    $.ajax({
      url: url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({
          pagination: data.pagination,
          tenders: data.tenders,
          results_count: data.results_count,
        });
        history.pushState({ url: url }, '', url.replace('/api/v1',''));
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(url, status, err.toString());
      }.bind(this),
      complete: function(xhr, status){
        document.body.classList.remove('loading');
      }
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
        this.setState({tenders: tenders}, function(){
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
        document.body.classList.remove('loading');
      }
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
        this.setState({tenders: tenders}, function(){
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
        document.body.classList.remove('loading');
      }
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
        document.body.classList.remove('loading');
      }
    });
  },
  showLoading: function(){
    document.body.classList.add('loading');
  },
  render: function(){
    var descriptionText = <p>These are tenders that have been closed, awarded and/or cancelled. You can no longer apply for these tenders.<br/><br/>We have included these tenders here for your reference!</p>;
    return (
      <div id='wrapper'>
        <TendersDescription descriptionText={descriptionText} />
        <GenericTendersResults url={this.props.url} pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} showLoading={this.showLoading} tenders={this.state.tenders} unwatchTender={this.unwatchTender} watchTender={this.watchTender} showTender={this.showTender} />
      </div>
    );
  }
});