var PostedTendersResults = React.createClass({
  render: function() {
    return (
      <section id='tender-results'>
        <div className='row'>
          <div className='small-12 column'>
            <TendersPagination {...this.props} />
            <table id='results-table' role='grid'>
              <PostedTendersTableHeader />
              <PostedTendersTableBody {...this.props} />
            </table>
            <TendersPagination {...this.props} />
          </div>
        </div>
      </section>
    );
  }
});