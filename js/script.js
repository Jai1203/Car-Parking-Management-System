// Move to js/script.js
document.addEventListener('DOMContentLoaded', function() {
    // Navigation smooth scrolling
    document.querySelectorAll('nav a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Register form submission
    document.getElementById('register-form').addEventListener('submit', function(e) {
        e.preventDefault();
        registerCustomer();
    });

    // Login form submission
    document.getElementById('login-form').addEventListener('submit', function(e) {
        e.preventDefault();
        loginCustomer();
    });

    // Load parking slots
    loadParkingSlots();


    // Vehicle form submission
    document.getElementById('vehicle-form').addEventListener('submit', function(e) {
        e.preventDefault();
        registerVehicle();
    });
});

let csrfToken = '';

function registerCustomer() {
    const formData = {
        name: document.getElementById('reg-name').value,
        mobile: document.getElementById('reg-mobile').value,
        email: document.getElementById('reg-email').value,
        username: document.getElementById('reg-username').value,
        password: document.getElementById('reg-password').value,
        address: document.getElementById('reg-address').value
    };

    fetch('/api/auth/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        const messageDiv = document.getElementById('register-message');
        if (data.success) {
            messageDiv.innerHTML = `<p class="success">Registration successful! Please login.</p>`;
            document.getElementById('register-form').reset();
        } else {
            messageDiv.innerHTML = `<p class="error">${data.message}</p>`;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('register-message').innerHTML = 
            `<p class="error">An error occurred during registration.</p>`;
    });
}

function loginCustomer() {
    const formData = {
        username: document.getElementById('login-username').value,
        password: document.getElementById('login-password').value
    };

    fetch('/api/auth/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
        credentials: 'include'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        const messageDiv = document.getElementById('login-message');
        if (data.success) {
            messageDiv.innerHTML = `<p class="success">Login successful!</p>`;
            document.getElementById('login-form').reset();
            showCustomerDashboard(data.customer);
        } else {
            messageDiv.innerHTML = `<p class="error">${data.message}</p>`;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('login-message').innerHTML = 
            `<p class="error">An error occurred during login.</p>`;
    });
}

function showCustomerDashboard(customer) {
    document.getElementById('customer-dashboard').classList.remove('hidden');
    document.getElementById('customer-info').innerHTML = `
        <h3>Customer Information</h3>
        <p><strong>Name:</strong> ${customer.customer_name}</p>
        <p><strong>Email:</strong> ${customer.customer_email}</p>
        <p><strong>Mobile:</strong> ${customer.customer_mobile}</p>
        <p><strong>Address:</strong> ${customer.customer_address}</p>
    `;
    
    loadCustomerVehicles(customer.customer_id);
    loadCustomerBookings(customer.customer_id);
}

function loadCustomerVehicles(customerId) {
    fetch(`/api/vehicles/`, {
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        const vehiclesDiv = document.getElementById('customer-vehicles');
        if (data.vehicles && data.vehicles.length > 0) {
            let html = '<h3>My Vehicles</h3><ul>';
            data.vehicles.forEach(vehicle => {
                html += `
                    <li>
                        ${vehicle.vehicle_company} ${vehicle.vehicle_model}
                        <button onclick="bookSlot(${vehicle.vehicle_id})">Book Slot</button>
                    </li>
                `;
            });
            html += '</ul>';
            vehiclesDiv.innerHTML = html;
        } else {
            vehiclesDiv.innerHTML = '<p>No vehicles registered.</p>';
        }
    });
}

function loadCustomerBookings(customerId) {
    fetch(`/api/booking/`, {
        credentials: 'include'
    })
    .then(response => response.json())
    .then(data => {
        const bookingsDiv = document.getElementById('customer-bookings');
        if (data.length) {
            let html = '<h3>My Bookings</h3><ul>';
            data.forEach(booking => {
                html += `
                    <li>
                        Slot ${booking.parking_slot_id} - 
                        ${new Date(booking.entry_time).toLocaleString()}
                        <button onclick="releaseSlot(${booking.transaction_id})">Release</button>
                    </li>
                `;
            });
            html += '</ul>';
            bookingsDiv.innerHTML = html;
        } else {
            bookingsDiv.innerHTML = '<p>No active bookings.</p>';
        }
    });
}

function loadParkingSlots() {
    fetch('/api/parking', {
        credentials: 'include'
    })
    .then(response => {
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        return response.json();
    })
    .then(data => {
        const container = document.getElementById('parking-slots-container');
        let html = '';
        data.slots.forEach(slot => {
            const statusClass = slot.isOccupied ? 'slot-occupied' : 'slot-available';
            html += `
                <div class="parking-slot ${statusClass}">
                    <div>
                        <h3>Slot ${slot.id}</h3>
                        <p>Type: ${slot.type}</p>
                        <p>${slot.description || ''}</p>
                        <p>Fee: $${slot.rate}/hour</p>
                    </div>
                    <div>
                        <p><strong>${slot.isOccupied ? 'Occupied' : 'Available'}</strong></p>
                    </div>
                </div>
            `;
        });
        container.innerHTML = html;
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById('parking-slots-container').innerHTML = 
            '<p class="error">Failed to load parking slots. Please refresh the page.</p>';
    });
}

function bookSlot(vehicle_id) {
    const slot_id = prompt("Enter slot number:");
    if (!slot_id) return;

    fetch('/api/booking/book', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({ 
            vehicle_id,
            slot_id
        })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert('Slot booked successfully!');
            loadParkingSlots();
            const customerId = document.getElementById('customer-info').dataset.customerId;
            loadCustomerBookings(customerId);
        } else {
            alert(data.message || 'Failed to book slot');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to book slot. Please try again.');
    });
}

function releaseSlot(bookingId) {
    if (!confirm("Are you sure you want to release this parking slot?")) return;

    fetch(`/api/booking/${bookingId}`, {
        method: 'delete',
        credentials: 'include'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert(`Slot released. Total fee: $${data.fee.toFixed(2)}`);
            loadParkingSlots();
            const customerId = document.getElementById('customer-info').dataset.customerId;
            loadCustomerBookings(customerId);
        } else {
            alert(data.message || 'Failed to release slot');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to release slot. Please try again.');
    });
}

function registerVehicle() {
    const customerId = document.getElementById('customer-info').dataset.customerId;
    const formData = {
        customerId: parseInt(customerId),
        make: document.getElementById('vehicle-make').value,
        model: document.getElementById('vehicle-model').value,
        year: document.getElementById('vehicle-year').value,
        color: document.getElementById('vehicle-color').value,
        licensePlate: document.getElementById('vehicle-plate').value
    };

    fetch('/api/vehicles', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
        credentials: 'include'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert('Vehicle registered successfully!');
            document.getElementById('vehicle-form').reset();
            loadCustomerVehicles(customerId);
        } else {
            alert(data.message || 'Failed to register vehicle');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to register vehicle. Please try again.');
    });
}