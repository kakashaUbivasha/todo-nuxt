<script setup>
import { ref, onMounted } from "vue";

// Получаем todoId напрямую из defineProps
const props = defineProps({
  todoId: Number,
});

// Переменные
const todo = ref(null);
const originalTodo = ref(null);
const history = ref([]); // Стек для отмены
const redoStack = ref([]); // Стек для повторения
const newTaskName = ref(""); // Переменная для новой задачи

// Функция для поиска todo по id
const findTodoById = (id) => {
  const todos = JSON.parse(localStorage.getItem("todos") || "[]");
  todo.value = todos.find((item) => item.id == id) || null;
  originalTodo.value = JSON.parse(JSON.stringify(todo.value));
  if (!todo.value) {
    console.log("Задача с таким id не найдена");
  }
};

// Добавление действия в историю
const addHistory = (action) => {
  history.value.push(action);
  redoStack.value = []; // Очищаем стек redo при новом действии
};

// Применение действия
const applyAction = (action, isUndo) => {
  const task = todo.value.items[action.index];
  switch (action.type) {
    case "editTask":
      task.task = isUndo ? action.oldValue : action.newValue;
      break;
    case "toggleChecked":
      task.isChecked = isUndo ? action.newValue : !action.newValue;
      console.log(task.isChecked);
      break;
    case "deleteTask":
      if (isUndo) {
        todo.value.items.splice(action.index, 0, action.task);
      } else {
        todo.value.items.splice(action.index, 1);
      }
      break;
    case "editTitle":
      todo.value.title = isUndo ? action.oldValue : action.newValue;
      break;
    case "addTask":
      if (isUndo) {
        // Если отмена, удаляем задачу по индексу
        todo.value.items.splice(action.index, 1);
      } else {
        todo.value.items.push(action.task);
      }
      break;
  }
};

// Undo (отменить изменение)
const undo = () => {
  if (history.value.length > 0) {
    const lastAction = history.value.pop();
    redoStack.value.push(lastAction);
    applyAction(lastAction, true);
  }
};

// Redo (повторить изменение)
const redo = () => {
  if (redoStack.value.length > 0) {
    const action = redoStack.value.pop();
    history.value.push(action);
    applyAction(action, false);
  }
};

// Изменение названия задачи
const changeTaskName = (id) => {
  const task = todo.value.items[id];
  const confirmChange = window.confirm("Вы уверены, что хотите изменить эту задачу?");
  if (confirmChange) {
    const newTask = prompt("Введите новое название задачи:", task.task);
    if (newTask !== null) {
      addHistory({
        type: "editTask",
        index: id,
        oldValue: task.task,
        newValue: newTask.trim(),
      });
      task.task = newTask.trim();
    }
  }
};

// Переключение состояния выполнения
const toggleChecked = (id) => {
  const task = todo.value.items[id];
  addHistory({
    type: "toggleChecked",
    index: id,
    newValue: !task.isChecked,
  });
  const confirmDeletion = window.confirm("Вы уверены, что хотите отметить эту задачу?");
  if(!confirmDeletion) {
    todo.value.items[id].isChecked = !todo.value.items[id].isChecked
  }
};

// Удаление задачи
const deleteTask = (id) => {
  const confirmDeletion = window.confirm("Вы уверены, что хотите удалить эту задачу?");
  if (confirmDeletion) {
    const task = todo.value.items[id];
    addHistory({
      type: "deleteTask",
      index: id,
      task: { ...task },
    });
    todo.value.items.splice(id, 1);
  }
};

// Изменение названия заметки
const changeTitle = () => {
  const newTitle = prompt("Введите новое название заметки:", todo.value.title);
  if (newTitle !== null && newTitle.trim() !== "") {
    addHistory({
      type: "editTitle",
      oldValue: todo.value.title,
      newValue: newTitle.trim(),
    });
    todo.value.title = newTitle.trim();
  }
};

// Добавление новой задачи
const addTask = () => {
  if (newTaskName.value.trim() !== "") {
    const newTask = {
      id: Date.now(), // Уникальный ID для новой задачи
      task: newTaskName.value.trim(),
      isChecked: false,
    };
    const index = todo.value.items.length;
    addHistory({
      type: "addTask",
      index,
      task: newTask,
    });
    todo.value.items.push(newTask); // Добавляем задачу в список
    newTaskName.value = ""; // Очищаем поле ввода
  } else {
    alert("Название задачи не может быть пустым.");
  }
};

// Отмена всех изменений
const cancelChange = () => {
  const confirmCancel = window.confirm("Вы уверены, что хотите отменить все изменения?");
  if (confirmCancel) {
    todo.value = JSON.parse(JSON.stringify(originalTodo.value));
    history.value = [];
    redoStack.value = [];
  }
};

// Сохранение изменений
const saveChange = () => {
  const todos = JSON.parse(localStorage.getItem("todos") || "[]");
  const index = todos.findIndex((item) => item.id == props.todoId);
  if (index !== -1) {
    todos[index] = todo.value;
    localStorage.setItem("todos", JSON.stringify(todos));
    alert("Изменения успешно сохранены!");
    navigateTo('/')
  } else {
    alert("Не удалось найти задачу для сохранения изменений.");
  }
};

onMounted(() => {
  findTodoById(props.todoId);
});
</script>

<template>
  <div class="max-w-4xl mx-auto p-4">
    <div v-if="todo" class="space-y-4">
      <!-- Заголовок заметки -->
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-bold text-gray-900">{{ todo.title }}</h1>
        <span @click="changeTitle" class="text-blue-500 cursor-pointer hover:underline">Изменить</span>
      </div>

      <!-- Добавление новой задачи -->
      <div class="flex items-center space-x-2">
        <input
            type="text"
            v-model="newTaskName"
            placeholder="Введите задачу"
            class="border border-gray-300 p-2 rounded-lg w-full"
        />
        <button
            @click="addTask"
            class="bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600"
        >
          Добавить задачу
        </button>
      </div>

      <!-- Список задач -->
      <ul class="space-y-2 mt-4">
        <li
            v-for="(task, index) in todo.items"
            :key="task.id"
            class="flex items-center space-x-4 p-2 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          <input
              type="checkbox"
              :id="task.id"
              v-model="task.isChecked"
              @change="toggleChecked(index)"
              class="h-5 w-5 text-blue-500 border-gray-300 rounded"
          />
          <label :for="task.id" class="flex-grow text-gray-800">{{ task.task }}</label>
          <button
              @click="changeTaskName(index)"
              class="text-blue-500 hover:text-blue-700"
          >
            Изменить
          </button>
          <button
              @click="deleteTask(index)"
              class="text-red-500 hover:text-red-700"
          >
            Удалить
          </button>
        </li>
      </ul>

      <div class="flex space-x-4 mt-4 flex-wrap gap-5">
        <button
            @click="undo"
            :disabled="history.length === 0"
            class="bg-gray-300 text-gray-700 p-2 rounded-lg cursor-pointer disabled:opacity-50"
        >
          Отменить
        </button>
        <button
            @click="redo"
            :disabled="redoStack.length === 0"
            class="bg-gray-300 text-gray-700 p-2 rounded-lg cursor-pointer disabled:opacity-50"
        >
          Повторить
        </button>
        <button
            @click="saveChange"
            class="bg-green-500 text-white p-2 rounded-lg hover:bg-green-600"
        >
          Сохранить
        </button>
        <button
            @click="cancelChange"
            class="bg-red-500 text-white p-2 rounded-lg hover:bg-red-600"
        >
          Отменить изменения
        </button>
      </div>
    </div>

    <p v-else class="text-red-500 mt-4">Задача с таким id {{ todoId }} не найдена</p>
  </div>
</template>

<style scoped>
/* Ваши стили */
</style>
