var GenericTendersTable = React.createClass({
  // propTypes: {
  //   tenders: React.PropTypes.array
  // },
  getInitialState: function() {
    return {tenders: []};
  },
  componentDidMount: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({tenders: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  render: function() {
    return (
      <table id='results-table' role='grid'>
        <GenericTendersTableHeader />
        <GenericTendersTableBody tenders={this.state.tenders}/>
      </table>
    );
  }
});