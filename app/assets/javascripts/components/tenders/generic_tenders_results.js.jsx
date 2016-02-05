var GenericTendersResults = React.createClass({
  render: function() {
    return (
      <section id='tender-results'>
        <div className='row'>
          <div className='small-12 column'>
            <TendersPagination {...this.props} />
            <table id='results-table' role='grid'>
              <GenericTendersTableHeader trial_tender_ids={this.props.trial_tender_ids} />
              <GenericTendersTableBody {...this.props} />
            </table>
            <TendersPagination {...this.props} />
          </div>
        </div>
      </section>
    );
  }
});