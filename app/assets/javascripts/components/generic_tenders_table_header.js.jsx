var GenericTendersTableHeader = React.createClass({
  render: function() {
    return (
      <thead>
        <th className='medium-5'>Description</th>
        <th className='medium-1'>Published Date</th>
        <th className='medium-1'>Closing Date</th>
        <th className='medium-1'>Closing Time</th>
        <th className='medium-2'>Buyer Entity</th>
        <th className='medium-1'>Watchlist</th>
        <th className='medium-1'>Details</th>
      </thead>
    );
  }
});