var GenericTendersResults = React.createClass({
  render: function() {
    return (
      <section id='tender-results'>
        <div className='row'>
          <div className='small-12 column'>
            <TendersPagination {...this.props} />
            <table id='results-table' role='grid'>
              <GenericTendersTableHeader />
              <GenericTendersTableBody {...this.props} />
            </table>
            <TendersPagination {...this.props} />
          </div>
        </div>
      </section>
    );
  }
});