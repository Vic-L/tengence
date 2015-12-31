var GenericTendersTable = React.createClass({
  propTypes: {
    tenders: React.PropTypes.array
  },

  render: function() {
    return (
      <table id='results-table' role='grid'>
        <GenericTendersTableHeader />
        <GenericTendersTableBody tenders={this.props.tenders}/>
      </table>
    );
  }
});