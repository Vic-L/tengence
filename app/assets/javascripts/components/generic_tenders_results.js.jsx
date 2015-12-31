var GenericTendersResults = React.createClass({
  // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: [], pagination: {}, results_count: null};
  },
  componentDidMount: function() {
    $.ajax({
      url: this.props.url,
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
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function() {
    return (
      <section id='tender-results'>
        <div className='row'>
          <div className='small-12 column'>
            <TendersPagination pagination={this.state.pagination} results_count={this.state.results_count}/>
            <table id='results-table' role='grid'>
              <GenericTendersTableHeader />
              <GenericTendersTableBody tenders={this.state.tenders}/>
            </table>
            <TendersPagination pagination={this.state.pagination} results_count={this.state.results_count}/>
          </div>
        </div>
      </section>
    );
  }
});