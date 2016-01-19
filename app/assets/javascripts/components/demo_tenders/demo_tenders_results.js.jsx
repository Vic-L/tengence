var DemoTendersResults = React.createClass({
  render: function() {
    return (
      <div className='row' id='tender-results'>
        <div className='small-12 column'>
          <DemoTendersPagination {...this.props} />
          <table id='results-table' role='grid'>
            <GenericTendersTableHeader />
            <DemoTendersTableBody {...this.props} />
          </table>
          <DemoTendersPagination {...this.props} />
        </div>
      </div>
    );
  }
});