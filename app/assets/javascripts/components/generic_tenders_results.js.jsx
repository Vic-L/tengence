var GenericTendersResults = React.createClass({
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
      url: '/api/v1/watched_tenders/' + ref_no,
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
          $("a.unwatch-button[data-gtm-label=" + ref_no + "]").notify(
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
  showLoading: function(){
    document.body.classList.add('loading');
  },
  render: function() {
    return (
      <section id='tender-results'>
        <div className='row'>
          <div className='small-12 column'>
            <TendersPagination pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} showLoading={this.showLoading}/>
            <table id='results-table' role='grid'>
              <GenericTendersTableHeader />
              <GenericTendersTableBody tenders={this.state.tenders} showLoading={this.showLoading} unwatchTender={this.unwatchTender} watchTender={this.watchTender}/>
            </table>
            <TendersPagination pagination={this.state.pagination} results_count={this.state.results_count} getTenders={this.getTenders} showLoading={this.showLoading}/>
          </div>
        </div>
      </section>
    );
  }
});