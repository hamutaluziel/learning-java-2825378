'use strict';

// ── State ──────────────────────────────────────────────────────────────────
let currentDate = todayKey();
let tempWater = 0;

function todayKey() {
  return new Date().toISOString().slice(0, 10); // YYYY-MM-DD
}

function getData(date) {
  const raw = localStorage.getItem('tracker_' + date);
  return raw ? JSON.parse(raw) : { foods: [], exercises: [], screenshots: [], notes: '', water: 0 };
}

function saveData(date, data) {
  localStorage.setItem('tracker_' + date, JSON.stringify(data));
}

// ── Date Navigation ─────────────────────────────────────────────────────────
function formatDateHebrew(dateStr) {
  const [y, m, d] = dateStr.split('-').map(Number);
  const date = new Date(y, m - 1, d);
  const days = ['ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת'];
  const months = ['ינואר','פברואר','מרץ','אפריל','מאי','יוני',
                  'יולי','אוגוסט','ספטמבר','אוקטובר','נובמבר','דצמבר'];
  const dayName = days[date.getDay()];
  if (dateStr === todayKey()) return `היום, ${d} ${months[m - 1]}`;
  const yesterday = new Date(); yesterday.setDate(yesterday.getDate() - 1);
  const yesterdayKey = yesterday.toISOString().slice(0, 10);
  if (dateStr === yesterdayKey) return `אתמול, ${d} ${months[m - 1]}`;
  return `${dayName}, ${d} ${months[m - 1]} ${y}`;
}

function shiftDate(delta) {
  const [y, m, d] = currentDate.split('-').map(Number);
  const dt = new Date(y, m - 1, d + delta);
  currentDate = dt.toISOString().slice(0, 10);
  renderAll();
}

document.getElementById('prevDay').addEventListener('click', () => shiftDate(-1));
document.getElementById('nextDay').addEventListener('click', () => shiftDate(1));

// ── Modal Helpers ────────────────────────────────────────────────────────────
function openModal(id) {
  if (id === 'foodModal') { tempWater = 0; document.getElementById('waterCount').textContent = '0'; resetFoodForm(); }
  if (id === 'exerciseModal') resetExerciseForm();
  document.getElementById(id).classList.add('open');
}

function closeModal(id) {
  document.getElementById(id).classList.remove('open');
}

function closeModalOnOverlay(event, id) {
  if (event.target === document.getElementById(id)) closeModal(id);
}

function resetFoodForm() {
  ['foodName','foodCalories','foodPortion','foodCarbs','foodProtein','foodFat'].forEach(id => {
    document.getElementById(id).value = '';
  });
  document.getElementById('foodMealType').value = 'breakfast';
  tempWater = 0;
  document.getElementById('waterCount').textContent = '0';
}

function resetExerciseForm() {
  document.getElementById('exerciseType').value = 'walking';
  document.getElementById('customExerciseName').value = '';
  document.getElementById('customExerciseGroup').style.display = 'none';
  ['exerciseDuration','exerciseCalories','exerciseDistance'].forEach(id => {
    document.getElementById(id).value = '';
  });
  document.getElementById('exerciseIntensity').value = 'medium';
  document.getElementById('exerciseNotes').value = '';
}

// ── Water Counter ────────────────────────────────────────────────────────────
function adjustWater(delta) {
  tempWater = Math.max(0, tempWater + delta);
  document.getElementById('waterCount').textContent = tempWater;
}

// ── Exercise Type Toggle ─────────────────────────────────────────────────────
document.getElementById('exerciseType').addEventListener('change', function () {
  document.getElementById('customExerciseGroup').style.display =
    this.value === 'other' ? 'block' : 'none';
});

// ── Add Food ─────────────────────────────────────────────────────────────────
function addFood() {
  const name = document.getElementById('foodName').value.trim();
  if (!name) { alert('נא להזין שם מזון'); return; }

  const entry = {
    id: Date.now(),
    name,
    calories: parseInt(document.getElementById('foodCalories').value) || 0,
    portion: document.getElementById('foodPortion').value.trim(),
    carbs: parseInt(document.getElementById('foodCarbs').value) || 0,
    protein: parseInt(document.getElementById('foodProtein').value) || 0,
    fat: parseInt(document.getElementById('foodFat').value) || 0,
    mealType: document.getElementById('foodMealType').value,
    water: tempWater,
    time: new Date().toLocaleTimeString('he-IL', { hour: '2-digit', minute: '2-digit' }),
  };

  const data = getData(currentDate);
  data.foods.push(entry);
  data.water = (data.water || 0) + tempWater;
  saveData(currentDate, data);
  closeModal('foodModal');
  renderAll();
}

// ── Add Exercise ─────────────────────────────────────────────────────────────
function addExercise() {
  const typeVal = document.getElementById('exerciseType').value;
  const typeLabels = {
    'walking': 'הליכה', 'fast-walking': 'הליכה מהירה', 'running': 'ריצה',
    'cycling': 'רכיבה על אופניים', 'swimming': 'שחייה', 'gym': 'חדר כושר',
    'yoga': 'יוגה / פילאטיס', 'dancing': 'ריקוד', 'other': 'אחר'
  };
  const customName = document.getElementById('customExerciseName').value.trim();
  const name = typeVal === 'other' ? (customName || 'פעילות גופנית') : typeLabels[typeVal];

  const entry = {
    id: Date.now(),
    type: typeVal,
    name,
    duration: parseInt(document.getElementById('exerciseDuration').value) || 0,
    calories: parseInt(document.getElementById('exerciseCalories').value) || 0,
    distance: parseFloat(document.getElementById('exerciseDistance').value) || 0,
    intensity: document.getElementById('exerciseIntensity').value,
    notes: document.getElementById('exerciseNotes').value.trim(),
    time: new Date().toLocaleTimeString('he-IL', { hour: '2-digit', minute: '2-digit' }),
  };

  const data = getData(currentDate);
  data.exercises.push(entry);
  saveData(currentDate, data);
  closeModal('exerciseModal');
  renderAll();
}

// ── Delete Items ─────────────────────────────────────────────────────────────
function deleteFood(id) {
  const data = getData(currentDate);
  const item = data.foods.find(f => f.id === id);
  if (item) data.water = Math.max(0, (data.water || 0) - (item.water || 0));
  data.foods = data.foods.filter(f => f.id !== id);
  saveData(currentDate, data);
  renderAll();
}

function deleteExercise(id) {
  const data = getData(currentDate);
  data.exercises = data.exercises.filter(e => e.id !== id);
  saveData(currentDate, data);
  renderAll();
}

// ── Screenshots ───────────────────────────────────────────────────────────────
function handleScreenshotUpload(event) {
  const files = Array.from(event.target.files);
  if (!files.length) return;

  const data = getData(currentDate);
  let pending = files.length;

  files.forEach(file => {
    const reader = new FileReader();
    reader.onload = e => {
      data.screenshots.push({
        id: Date.now() + Math.random(),
        dataUrl: e.target.result,
        name: file.name,
        time: new Date().toLocaleTimeString('he-IL', { hour: '2-digit', minute: '2-digit' }),
      });
      pending--;
      if (pending === 0) {
        saveData(currentDate, data);
        renderAll();
      }
    };
    reader.readAsDataURL(file);
  });

  event.target.value = '';
}

function deleteScreenshot(id) {
  const data = getData(currentDate);
  data.screenshots = data.screenshots.filter(s => s.id !== id);
  saveData(currentDate, data);
  renderAll();
}

// ── Lightbox ──────────────────────────────────────────────────────────────────
function openLightbox(dataUrl, caption) {
  document.getElementById('lightboxImg').src = dataUrl;
  document.getElementById('lightboxCaption').textContent = caption;
  document.getElementById('lightbox').classList.add('open');
}

function closeLightbox() {
  document.getElementById('lightbox').classList.remove('open');
}

// ── Notes ────────────────────────────────────────────────────────────────────
function saveNotes() {
  const data = getData(currentDate);
  data.notes = document.getElementById('dailyNotes').value;
  saveData(currentDate, data);
  const btn = document.querySelector('#notesSection .btn-secondary');
  btn.textContent = '✓ נשמר!';
  setTimeout(() => { btn.textContent = 'שמור הערות'; }, 1500);
}

// ── Render ────────────────────────────────────────────────────────────────────
const mealTypeLabels = {
  breakfast: 'ארוחת בוקר', lunch: 'ארוחת צהריים',
  dinner: 'ארוחת ערב', snack: 'חטיף'
};

const intensityLabels = { low: 'נמוכה', medium: 'בינונית', high: 'גבוהה' };

function renderAll() {
  document.getElementById('currentDateLabel').textContent = formatDateHebrew(currentDate);
  const data = getData(currentDate);

  // Food list
  const foodList = document.getElementById('foodList');
  if (data.foods.length === 0) {
    foodList.innerHTML = '<div class="empty-state">לא נרשמו ארוחות היום</div>';
  } else {
    foodList.innerHTML = data.foods.map(f => `
      <div class="log-item">
        <div class="log-item-info">
          <div class="log-item-name">${escHtml(f.name)}</div>
          <div class="log-item-sub">
            ${f.portion ? escHtml(f.portion) + ' · ' : ''}${f.time}
            ${f.carbs || f.protein || f.fat ? ` · פ:${f.carbs}ג ח:${f.protein}ג ש:${f.fat}ג` : ''}
          </div>
        </div>
        <div class="log-item-right">
          <span class="meal-tag">${mealTypeLabels[f.mealType] || f.mealType}</span>
          ${f.calories ? `<span class="calorie-badge food-badge">${f.calories} קל'</span>` : ''}
          <button class="delete-btn" onclick="deleteFood(${f.id})" title="מחק">✕</button>
        </div>
      </div>
    `).join('');
  }

  // Exercise list
  const exerciseList = document.getElementById('exerciseList');
  if (data.exercises.length === 0) {
    exerciseList.innerHTML = '<div class="empty-state">לא נרשמה פעילות גופנית היום</div>';
  } else {
    exerciseList.innerHTML = data.exercises.map(e => `
      <div class="log-item">
        <div class="log-item-info">
          <div class="log-item-name">${escHtml(e.name)}</div>
          <div class="log-item-sub">
            ${e.duration ? e.duration + ' דקות' : ''}
            ${e.distance ? ' · ' + e.distance + ' ק"מ' : ''}
            ${e.notes ? ' · ' + escHtml(e.notes) : ''}
            ${e.time ? ' · ' + e.time : ''}
          </div>
        </div>
        <div class="log-item-right">
          <span class="intensity-tag intensity-${e.intensity}">${intensityLabels[e.intensity]}</span>
          ${e.calories ? `<span class="calorie-badge exercise-badge">−${e.calories} קל'</span>` : ''}
          <button class="delete-btn" onclick="deleteExercise(${e.id})" title="מחק">✕</button>
        </div>
      </div>
    `).join('');
  }

  // Screenshots
  const gallery = document.getElementById('screenshotGallery');
  if (data.screenshots.length === 0) {
    gallery.innerHTML = '<div class="empty-state">לא הועלו צילומי מסך היום — לחצי על "+ העלה צילום מסך"</div>';
  } else {
    gallery.innerHTML = data.screenshots.map(s => `
      <div class="screenshot-thumb" title="${escHtml(s.name)}">
        <img src="${s.dataUrl}" alt="${escHtml(s.name)}" onclick="openLightbox('${s.dataUrl}','${escHtml(s.name)} · ${s.time}')" />
        <div class="thumb-overlay">${escHtml(s.name)}</div>
        <button class="thumb-delete" onclick="event.stopPropagation(); deleteScreenshot(${s.id})" title="מחק">✕</button>
      </div>
    `).join('');
  }

  // Notes
  document.getElementById('dailyNotes').value = data.notes || '';

  // Summary
  const totalIn = data.foods.reduce((s, f) => s + (f.calories || 0), 0);
  const totalOut = data.exercises.reduce((s, e) => s + (e.calories || 0), 0);
  const net = totalIn - totalOut;

  document.getElementById('totalCaloriesIn').textContent = totalIn.toLocaleString();
  document.getElementById('totalCaloriesOut').textContent = totalOut.toLocaleString();
  const netEl = document.getElementById('netCalories');
  netEl.textContent = (net >= 0 ? '+' : '') + net.toLocaleString();
  netEl.style.color = net > 0 ? 'var(--orange)' : net < 0 ? 'var(--green)' : 'var(--primary)';
  document.getElementById('totalWater').textContent = data.water || 0;
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// ── Init ──────────────────────────────────────────────────────────────────────
renderAll();
